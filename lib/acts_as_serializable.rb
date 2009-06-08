module ActiveRecord
  module Acts
    module Serializable
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_serializable
          include ActiveRecord::Acts::Serializable::InstanceMethods
          extend ActiveRecord::Acts::Serializable::SingletonMethods

          self.class.instance_methods.each do |method|
            if method_match = method.match(/^serialize_to_version(.*)/)
              method_match[1].split('_').each do |number|
                @serialized_major_versions


              end
            end
          end

          class_eval <<-EOV
            include ActiveRecord::Acts::Serializable::InstanceMethods
          EOV
        end
      end

      # This module contains class methods
      module SingletonMethods
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
          if version = options[:version] || DEFAULT_VERSION
            version_string = "serialize_to_version_#{Serializable.version_method(version)}"
            if respond_to?(version_string)
              return send(version_string, builder, options)
            end
          end

          raise 'serialize method was not implemented'
        end
      end

    end
  end
end
