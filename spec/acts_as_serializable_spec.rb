require 'spec/spec_helper'

class SerializableObject
  include Serializable

  def serialize_to_version_1_0_0(builder, options)
    "This is version 1.0.0"
  end

  def serialize_to_version_1_5(builder, options)
    "This is version 1.5.0"
  end

  def serialize_to_version_2_1(builder, options)
    "This is version 2.1"
  end

  acts_as_serializable
end

class WithSerialize < SerializableObject
  def serialize(builder, options)
    builder
  end
end


describe Serializable, 'when included in a class, that class' do

  it 'should respond to #to_xml(options)' do
    klass = SerializableObject.new
    klass.respond_to?("to_xml").should be_true
  end

  it 'should respond to #to_json(options)' do
    klass = SerializableObject.new
    klass.respond_to?("to_hash").should be_true
  end

  it 'should respond to #to_hash(options)' do
    klass = SerializableObject.new
    klass.respond_to?("to_json").should be_true
  end

  context 'with the serialized method overriden to return the builder, then' do

    it '#to_xml should return an Builder::XmlMarkup' do
      klass = WithSerialize.new
      klass.to_xml.test.should == "<test/>"
    end

    it '#to_hash should return an Builder::Hash' do
      klass = WithSerialize.new
      klass.to_hash.test('value').should == 'value'
    end

    it '#to_json should return an Builder::Json' do
      klass = WithSerialize.new
      klass.to_json.test('value').should == '"value"'
    end
  end

end

describe Serializable, 'when included in a class that has multible versioned serialization methods' do

  context 'and a to_format method is called with a version option' do

    it 'should execute that exact versioned serialization assuming it exists' do
      klass = SerializableObject.new

      klass.to_xml(:version => '1.0.0').should == "This is version 1.0.0"
      klass.to_json(:version => '1.5.0').should == "This is version 1.5.0"
      klass.to_hash(:version => '2.1.0').should == "This is version 2.1"
    end

    it 'should execute a lower version if an exact one does not exist' do
      klass = SerializableObject.new

      klass.to_xml(:version => '1.4.0').should == "This is version 1.0.0"
      klass.to_json(:version => '3.1.0').should == "This is version 2.1"
    end

    it 'should raise an error if no corresponding version exists' do
      klass = SerializableObject.new

      lambda { klass.to_hash(:version => '0.1.0') }.should raise_error(RuntimeError, "Version 0.1.0 given but no serialization method found")
    end
  end

  context 'and a to_format method is called with no version option' do

    it 'should default to the most recent version if no global default is set' do
      klass = SerializableObject.new

      klass.to_xml.should == "This is version 2.1"
    end
  end
end
