require 'builder/xmlmarkup'
require 'jsonbuilder'

module Serializable
  SERIALIZE_TO_VERSION_REGEXP = /^serialize_to_version_((:?\d+_?)+)$/
  SERIALIZED_CLASS_NAME_REGEXP = /^version_((?:\d+_?)+)$/

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def acts_as_serializable
      include Serializable::InstanceMethods
      extend Serializable::SingletonMethods
      @serialization_versions = Versions.new
      find_local_serialization_methods
      @default_serialization_version = @serialization_versions.last
    end
  end

  module SingletonMethods
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

    def serialization_versions
      @serialization_versions
    end

    def default_serialization_version
      @default_serialization_version
    end

    def default_serialization_version=(new_version)
      if new_version.is_a?(Version)
        @default_serialization_version = new_version
      else
        @default_serialization_version = Version.new(new_version)
      end
    end

    private

    def find_local_serialization_methods
      self.instance_methods.each do |method_name|
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
      if version_number = options[:version]
        if version = self.class.serialization_versions.find_version(Version.new(version_number))
          return self.send("serialize_to_version_#{version.to_s_underscored}", builder, options)
        else
          raise "Version #{version_number} given but no serialization method found"
        end
      else
        if version = self.class.default_serialization_version
          return self.send("serialize_to_version_#{version.to_s_underscored}", builder, options)
        else
          raise "No serialization method found"
        end
      end
    end
  end

end
