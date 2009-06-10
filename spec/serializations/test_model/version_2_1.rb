module Serializable
  module TestModel
    class Version_2_1
      def self.serialize(test_model, builder, options)
        "This is version 2.1 for #{test_model.class.name}"
      end
    end
  end
end
