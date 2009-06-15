require 'jsonbuilder'
require 'active_support'
require 'find'

module Serializable
  SERIALIZE_TO_VERSION_REGEXP = /^serialize_to_version_((:?\d+_?)+)$/
  SERIALIZED_CLASS_NAME_REGEXP = /\/version_((:?\d+_?)+)\.rb$/

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def acts_as_serializable
      include Serializable::InstanceMethods
      extend Serializable::SingletonMethods
      @serialization_versions = Versions.new
      find_local_serialization_methods
      if defined?(RAILS_ROOT)
        # Rails plugin usage
        scan_rails_app_paths.each do |path|
          find_project_serialization_classes(path)
        end
      end
    end
  end

  module SingletonMethods
    def find_project_serialization_classes(project_path)
      klass_name = self.name
      serialization_directory = File.join(project_path, 'serializations', klass_name.underscore)
      Find.find(serialization_directory) do |path|
        if File.file?(path) && versioned_klass = path.match(SERIALIZED_CLASS_NAME_REGEXP)
          require path
          klass = Serializable.const_get("#{klass_name}").const_get("Version_#{versioned_klass[1]}")
          if klass && klass.respond_to?(:serialize)
            define_local_serialization_method(versioned_klass[1])
          end
        end
      end
      @default_serialization_version = @serialization_versions.last
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
      @default_serialization_version = @serialization_versions.last
    end

    def define_local_serialization_method(method_version)
      class_eval <<-EOV
        def serialize_to_version_#{method_version}(builder, options)
          Serializable::#{self.name}::Version_#{method_version}.serialize(self, builder, options)
        end
      EOV
      @serialization_versions << Version.new(method_version)
    end

    def scan_rails_app_paths
      project_paths = Array.new
      $LOAD_PATH.each do |path|
        if path.match(/#{Regexp.escape(RAILS_ROOT)}.*\/app$/)
          project_paths << path
        end
      end
      project_paths
    end
  end

  # This module contains instance methods
  module InstanceMethods
    def to_hash(options = {})
      serialize(Builder::HashStructure.new, options)
    end

    def to_json(options = {})
      serialize(Builder::JsonFormat.new, options).to_json
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

    def serialize_for(builder, options = {})
      self.send(builder.serialization_method!, options)
    end
  end

end
