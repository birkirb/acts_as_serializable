module Serializable
  SERIALIZE_TO_VERSION_REGEXP = /^serialize_to_version((?:\d+_?)+)$/
  SERIALIZED_CLASS_NAME_REGEXP = /^version_((?:\d+_?)+)$/

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def acts_as_serializable
      include Serializable::InstanceMethods
      @serialization_versions = Versions.new
      find_local_serialization_methods
    end

    def find_project_serialization_classes(project_path)
      klass_name = self.class.name
      serialization_directory = File.join(project_path, 'serializations', klass_name.underscore)
      klasses = Array.new
      Find.find(serialization_directory) do |path|
        if File.file?(path) && versioned_klass = path.match(SERIALIZED_CLASS_NAME_REGEXP)
          require path
          klass = self.const_get("Serializable::#{klass_name}::Version_#{versioned_klass[1]}")
          if klass && klass.responds_to?("serialize")
            define_local_serialization_method(versioned_klass[1])
            @serialization_versions << Version.new(versioned_klass[1])
          end
        end
      end
    end

    protected

    def serialization_version
      @serialization_version
    end

    private

    def find_local_serialization_methods
      self.class.instance_methods.each do |method_name|
        if method_name = method_name.match(SERIALIZE_TO_VERSION_REGEXP)
          @serialization_versions << Version.new(method_name[1])
        end
      end
    end

    def define_local_serialization_method(method_version)
      class_eval <<-EOV
        def serialize_to_version_#{method_version}(builder, options)
          Serializable::#{self.class.name}::Version#{method_version}.serialize(self, builder, options)
        end
      EOV
    end
  end

  # This module contains instance methods
  module InstanceMethods
    def to_hash(options = {})
      serialize(Builder::Hash.new, options)
    end

    def to_json(options = {})
      serialize(Builder::Json.new, options)
    end

    def to_xml(options = {})
      serialize(Builder::XmlMarkup.new, options)
    end

    def serialize(builder, options = {})
      if version_number = options[:version] || (defined?(DEFAULT_VERSION) && DEFAULT_VERSION)
        if version = self.class.serialization_versions.find_version(Version.new(version_number))
          return self.send("serialized_to_version_#{version.to_s}", builder, options)
        else
          raise "Version #{version_number} given but no serialization method found"
        end
      end
    end
  end

end
