require 'jsonbuilder'
require 'active_support'
require 'find'
require 'serializable/version'

module Serializable
  SERIALIZE_TO_VERSION_REGEXP = /^serialize_to_version_((:?\d+_?)+)$/
  SERIALIZED_CLASS_NAME_REGEXP = /\/version_((:?\d+_?)+)\.rb$/

  def self.included(base)
    base.extend(ClassMethods)
  end

  def self.scan_rails_app_paths
    if defined?(RAILS_ROOT)
      # Rails plugin usage
      project_paths = Array.new
      # The app directory itself is not in $LOAD_PATH in Rails 3
      project_paths << Rails.root.join('app') if defined?(Rails) && File.exists?(Rails.root.join('app'))
      $LOAD_PATH.each do |path|
        if path.match(/#{Regexp.escape(RAILS_ROOT)}.*\/app$/)
          project_paths << path
        end
      end
      project_paths
    else
      Array.new
    end
  end

  SERIALIZATION_PROJECT_PATHS = Serializable.scan_rails_app_paths

  module ClassMethods
    def acts_as_serializable
      include Serializable::InstanceMethods
      extend Serializable::SingletonMethods
      @serialization_versions = Versions.new
      find_local_serialization_methods
      SERIALIZATION_PROJECT_PATHS.each do |path|
        find_project_serialization_classes(path)
      end
    end
  end

  module SingletonMethods
    def find_project_serialization_classes(project_path)
      klass_name = self.name
      serialization_directory = File.expand_path(File.join(project_path, 'serializations', klass_name.underscore))
      if File.exist?(serialization_directory)
        Find.find(serialization_directory) do |path|
          if File.file?(path) && versioned_klass = path.match(SERIALIZED_CLASS_NAME_REGEXP)
            require path
            klass = Serializations.const_get("#{klass_name}").const_get("Version_#{versioned_klass[1]}")
            if klass && klass.respond_to?(:serialize)
              define_local_serialization_method(versioned_klass[1])
            end
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
        if method_name = SERIALIZE_TO_VERSION_REGEXP.match(method_name)
          @serialization_versions << Version.new(method_name[1])
        end
      end
      @default_serialization_version = @serialization_versions.last
    end

    def define_local_serialization_method(method_version)
      class_eval(<<-EOV, __FILE__, __LINE__)
        def serialize_to_version_#{method_version}(builder, options, &block)
          Serializations::#{self.name}::Version_#{method_version}.serialize(self, builder, options, &block)
        end
      EOV
      @serialization_versions << Version.new(method_version)
    end
  end

  # This module contains instance methods
  module InstanceMethods
    def to_hash(options = {}, &block)
      serialize(Builder::HashStructure.new, options, &block)
    end

    def to_json(options = {}, &block)
      serialize(Builder::HashStructure.new, options, &block).to_json
    end

    def to_xml(options = {}, &block)
      serialize(Builder::XmlMarkup.new, options, &block)
    end

    def serialize(builder, options = {}, &block)
      if version_number = options[:version]
        version = version_number.is_a?(Serializable::Version) ? version_number : Version.new(version_number)
        if found_version = self.class.serialization_versions.find_version(version)
          return self.send("serialize_to_version_#{found_version.to_s_underscored}", builder, options, &block)
        else
          raise "Version #{version} given but no serialization method found"
        end
      else
        if version = self.class.default_serialization_version
          return self.send("serialize_to_version_#{version.to_s_underscored}", builder, options, &block)
        else
          raise "No serialization method found"
        end
      end
    end

    def serialize_for(builder, options = {}, &block)
      self.send(builder.serialization_method!, options, &block)
    end
  end

end
