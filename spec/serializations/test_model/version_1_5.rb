module Serializations
  module TestModel
    class Version_1_5
      def self.serialize(test_model, builder, options)
        if block_given?
          klass = yield(builder)
        else
          klass = test_model.class.name
        end
        "This is version 1.5.0 for #{klass}"
      end
    end
  end
end
