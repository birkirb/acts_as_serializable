require 'spec/spec_helper'

describe Serializable::Version, 'when created with a version numeric string' do

  it 'should report the correct major, minor, build and revision numbers.' do
    version = Serializable::Version.new('1.2.3.4')
    version.major.should == 1
    version.minor.should == 2
    version.build.should == 3
    version.revision.should == 4
  end

  it '#to_s should give the same version string.' do
    version = Serializable::Version.new('2.1.2')
    version.to_s.should == '2.1.2'
  end

  it '#to_s_underscored should give an underscored version string.' do
    version = Serializable::Version.new('2.1.2')
    version.to_s_underscored.should == '2_1_2'
  end

  it 'should give 0 for all numbers not specified.' do
    version = Serializable::Version.new('3')
    version.major.should == 3
    version.minor.should == 0
    version.build.should == 0
    version.revision.should == 0
  end

  it 'should support underscored versions' do
    version = Serializable::Version.new('3_1_2_4')
    version.major.should == 3
    version.minor.should == 1
    version.build.should == 2
    version.revision.should == 4
  end
end

describe Serializable::Version, 'when comparing two instances' do

  it 'should correctly compare v1.0.0.1 > v.1.0.0.0' do
    Serializable::Version.new('1.0.0.1').should > Serializable::Version.new('1.0')
    Serializable::Version.new('1.0.0.1').should_not < Serializable::Version.new('1.0')
    Serializable::Version.new('1.0.0.1').should_not == Serializable::Version.new('1.0')
  end

  it 'should correctly compare v1.2.0.3 < v2.2.0.3' do
    Serializable::Version.new('1.2.0.3').should < Serializable::Version.new('2.2.0.3')
    Serializable::Version.new('1.2.0.3').should_not > Serializable::Version.new('2.2.0.3')
    Serializable::Version.new('1.2.0.3').should_not == Serializable::Version.new('2.2.0.3')
  end

  it 'should correctly compare v2.0.0.0.0.0.0 == v2' do
    Serializable::Version.new('2.0.0.0.0.0.0.0').should == Serializable::Version.new('2')
    Serializable::Version.new('2.0.0.0.0.0.0.0').should_not < Serializable::Version.new('2')
    Serializable::Version.new('2.0.0.0.0.0.0.0').should_not > Serializable::Version.new('2')
  end
end

describe Serializable::Version, 'when in an Array' do

  it 'should be sortable' do
    version_strings_unordered = ['1.20.0', '1.0.2', '1.0.0', '1.4.0', '1.0.1', '2', '1.0.10', '2.0.1', '1.0']
    version_strings_ordered = ['1.0', '1.0.0', '1.0.1', '1.0.2', '1.0.10', '1.4.0', '1.20.0', '2', '2.0.1']
    versions = Array.new
    version_strings_unordered.each do |s|
      versions << Serializable::Version.new(s)
    end

    versions.sort.each_with_index do |version, index|
      version.to_s.should == version_strings_ordered[index]
    end
  end
end
