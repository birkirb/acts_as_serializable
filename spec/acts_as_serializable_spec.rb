require 'spec_helper'

class SerializableObject
  include Serializable

  def serialize_to_version_1_0_0(builder, options)
    "This is version 1.0.0"
  end

  def serialize_to_version_1_5(builder, options)
    postfix = if block_given?
      yield(builder)
    end
    "This is version 1.5.0#{postfix}"
  end

  def serialize_to_version_2_1(builder, options)
    "This is version 2.1"
  end

  acts_as_serializable
end

class WithSerialize < SerializableObject
  include Serializable
  acts_as_serializable

  def serialize(builder, options)
    builder.test('value')
  end
end

class NoSerializationObject
  include Serializable
  acts_as_serializable
end

class TestModel
  include Serializable
  acts_as_serializable
  find_project_serialization_classes(File.join(File.dirname(__FILE__)))
end

class TestRailsModel
  include Serializable
  acts_as_serializable
end

describe Serializable, 'if included in a class, then that class' do

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

  context 'with the serialized method overriden to return the builder' do

    it '#to_xml should return an Builder::XmlMarkup serialization' do
      klass = WithSerialize.new
      klass.to_xml.should == "<test>value</test>"
    end

    it '#to_hash should return an Builder::HashStructure serialization' do
      klass = WithSerialize.new
      klass.to_hash.should == 'value'
    end

    it '#to_json should return an Builder::JsonFormat serialization' do
      klass = WithSerialize.new
      klass.to_json.should == '"value"'
    end
  end
end

describe Serializable, 'when included in a class that has multiple versioned serialization methods' do

  context 'and a to_format method is called with a version option' do

    it 'should execute that exact versioned serialization assuming it exists' do
      klass = SerializableObject.new

      klass.to_xml(:version => '1.0.0').should == "This is version 1.0.0"
      klass.to_json(:version => '1.5.0').should == "\"This is version 1.5.0\""
      klass.to_hash(:version => '2.1.0').should == "This is version 2.1"
    end

    it 'should execute a lower version if an exact one does not exist' do
      klass = SerializableObject.new

      klass.to_xml(:version => '1.4.0').should == "This is version 1.0.0"
      klass.to_json(:version => '3.1.0').should == "\"This is version 2.1\""
    end

    it 'should raise an error if no corresponding version exists' do
      klass = SerializableObject.new

      lambda { klass.to_hash(:version => '0.1.0') }.should raise_error(RuntimeError, "Version 0.1.0 given but no serialization method found")
    end

    it '#serialize_for should call a to_format methods for a given builder' do
      klass = SerializableObject.new

      klass.serialize_for(Builder::XmlMarkup.new).should == "This is version 2.1"
      klass.serialize_for(Builder::JsonFormat.new).should == "\"This is version 2.1\""
      klass.serialize_for(Builder::HashStructure.new).should == "This is version 2.1"
    end
  end

  context 'and a to_format method is called with no version option' do

    it 'should default to the most recent version if no global default is set' do
      klass = SerializableObject.new

      klass.to_xml.should == "This is version 2.1"
    end

    it 'should throw an error if no serialization method exists' do
      klass = NoSerializationObject.new

      lambda { klass.to_xml }.should raise_error(RuntimeError, "No serialization method found")
    end

    it 'should use the default method if it is set' do
      SerializableObject.default_serialization_version = Serializable::Version.new('1.5')
      klass = SerializableObject.new

      klass.to_xml.should == "This is version 1.5.0"
    end

    it 'should pass on blocks' do
      SerializableObject.default_serialization_version = Serializable::Version.new('1.5')
      klass = SerializableObject.new

      klass.to_xml { '.1' }.should == "This is version 1.5.0.1"
    end
  end
end

describe Serializable, 'when included in a class that has multiple serialization classes' do

  context 'and a to_format method is called with a version option' do

    it 'should execute that exact versioned serialization assuming it exists' do
      klass = TestModel.new

      klass.to_xml(:version => '1.0.0').should == "This is version 1.0.0 for TestModel"
      klass.to_json(:version => '1.5.0').should == "\"This is version 1.5.0 for TestModel\""
      klass.to_hash(:version => '2.1.0').should == "This is version 2.1 for TestModel"
    end

    it 'should execute a lower version if an exact one does not exist' do
      klass = TestModel.new

      klass.to_xml(:version => '1.4.0').should == "This is version 1.0.0 for TestModel"
      klass.to_json(:version => '3.1.0').should == "\"This is version 2.1 for TestModel\""
    end

    it 'should raise an error if no corresponding version exists' do
      klass = TestModel.new

      lambda { klass.to_hash(:version => '0.1.0') }.should raise_error(RuntimeError, "Version 0.1.0 given but no serialization method found")
    end
  end

  context 'and a to_format method is called with no version option' do

    it 'should default to the most recent version if no global default is set' do
      klass = TestModel.new

      klass.to_xml.should == "This is version 2.1 for TestModel"
    end

    it 'should use the default method if it is set' do
      TestModel.default_serialization_version = "1.5"
      klass = TestModel.new

      klass.to_xml.should == "This is version 1.5.0 for TestModel"
    end

    it 'should auto find version classes for Rails applications' do
      klass = TestRailsModel.new

      klass.to_xml(:version => '1.0.0').should == "This is version 1.0.0 for TestRailsModel"
      klass.to_json(:version => '1.5.0').should == "\"This is version 1.5.0 for TestRailsModel\""
      klass.to_hash(:version => '2.1.0').should == "This is version 2.1 for TestRailsModel"
    end

    it 'should pass on blocks' do
      TestModel.default_serialization_version = "1.5"
      klass = TestModel.new

      klass.to_hash { 'BlockedInsertion' }.should == "This is version 1.5.0 for BlockedInsertion"
    end
  end
end
