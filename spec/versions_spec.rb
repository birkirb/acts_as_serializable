require 'spec_helper'

describe Serializable::Versions do

  it '#find_version should find a Version equal or less than the Version given ' do
    version_strings_unordered = ['1.20.0', '1.0.2', '1.0.0', '1.4.0', '1.0.1', '2', '1.0.10', '2.0.1', '1.0']
    versions = Serializable::Versions.new
    version_strings_unordered.each do |s|
      versions << Serializable::Version.new(s)
    end

    versions.push(Serializable::Version.new('1.3')) # Hmm..

    versions.find_version(Serializable::Version.new('1.30')).should == Serializable::Version.new('1.20.0')
    versions.find_version(Serializable::Version.new('1.15')).should == Serializable::Version.new('1.4.0')
    versions.find_version(Serializable::Version.new('1.0.2')).should == Serializable::Version.new('1.0.2')
    versions.find_version(Serializable::Version.new('3.1.5')).should == Serializable::Version.new('2.0.1')
  end
end
