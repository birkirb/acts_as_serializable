module Serializable
  class Versions < Array

    def <<(object)
      super(object)
      self.sort!
    end

    def push(object)
      super(object)
      self.sort!
    end

    def find_version(seeking_version)
      previous_version = nil

      if seeking_version.is_a?(Version)
        self.each do |version|
          if version < seeking_version
            previous_version = version
          elsif version > seeking_version
            return previous_version
          else
            return version
          end
        end
      end
      previous_version
    end
  end
end
