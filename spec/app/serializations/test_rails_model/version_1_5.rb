module Serializations
  module TestRailsModel
    class Version_1_5
      def self.serialize(test_model, builder, options)
        "This is version 1.5.0 for #{test_model.class.name}"
      end
    end
  end
end
