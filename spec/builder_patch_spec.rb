require 'spec/spec_helper'

describe Builder::XmlMarkup, 'having been patched' do
  it 'should support #serialization_method' do
    Builder::XmlMarkup.new.serialization_method!.should == :to_xml
  end
end

describe Builder::HashStructure, 'having been patched' do
  it 'should support #serialization_method' do
    Builder::HashStructure.new.serialization_method!.should == :to_hash
  end
end

describe Builder::JsonFormat, 'having been patched' do
  it 'should support #serialization_method' do
    Builder::JsonFormat.new.serialization_method!.should == :to_json
  end
end
