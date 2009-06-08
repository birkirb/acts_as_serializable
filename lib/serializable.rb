module VersionedSerialization

  attr_accessor :major, :minor, :release

  def serialize(builder, options = {})
    klass_serialization = self.class.name  + "Serialization"
    klass = const_get(klass_serialization)

    if version = options[:version] || DEFAULT_VERSION
      versioned_class = klass_serialization + klass.subclasses.grep(version)
      return const_get(versioned_class).new.serialize(builder, options)
    end
  end

  # Returns a version string for method names
  #   1.1.3 => 1_1_3
  def self.version_method(version)
    version.sub('.', '_')
  end
end
