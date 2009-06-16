module Serializations
  module TestModel
    class Version_1_0_0
      def self.serialize(test_model, builder, options)
        "This is version 1.0.0 for #{test_model.class.name}"
      end
    end
  end
end
