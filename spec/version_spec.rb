require 'spec/spec_helper'
require 'lib/version'

describe Version, 'when created with a version numeric string' do

  it 'should report the correct major, minor, build and revision numbers.' do
    version = Version.new('1.2.3.4')
    version.major.should == 1
    version.minor.should == 2
    version.build.should == 3
    version.revision.should == 4
  end

  it '#to_s should give the same version string.' do
    version = Version.new('2.1.2')
    version.to_s.should == '2.1.2'
  end

  it 'should give 0 for all numbers not specified.' do
    version = Version.new('3')
    version.major.should == 3
    version.minor.should == 0
    version.build.should == 0
    version.revision.should == 0
  end

  it 'should support underscored versions' do
    version = Version.new('3_1_2_4')
    version.major.should == 3
    version.minor.should == 1
    version.build.should == 2
    version.revision.should == 4
  end
end

describe Version, 'when comparing two instances' do

  it 'should correctly compare v1.0.0.1 > v.1.0.0.0' do
    Version.new('1.0.0.1').should > Version.new('1.0')
    Version.new('1.0.0.1').should_not < Version.new('1.0')
    Version.new('1.0.0.1').should_not == Version.new('1.0')
  end

  it 'should correctly compare v1.2.0.3 < v2.2.0.3' do
    Version.new('1.2.0.3').should < Version.new('2.2.0.3')
    Version.new('1.2.0.3').should_not > Version.new('2.2.0.3')
    Version.new('1.2.0.3').should_not == Version.new('2.2.0.3')
  end

  it 'should correctly compare v2.0.0.0.0.0.0 == v2' do
    Version.new('2.0.0.0.0.0.0.0').should == Version.new('2')
    Version.new('2.0.0.0.0.0.0.0').should_not < Version.new('2')
    Version.new('2.0.0.0.0.0.0.0').should_not > Version.new('2')
  end
end

describe Version, 'when in an Array' do

  it 'should be sortable' do
    version_strings_unordered = ['1.20.0', '1.0.2', '1.0.0', '1.4.0', '1.0.1', '2', '1.0.10', '2.0.1', '1.0']
    version_strings_ordered = ['1.0', '1.0.0', '1.0.1', '1.0.2', '1.0.10', '1.4.0', '1.20.0', '2', '2.0.1']
    versions = Array.new
    version_strings_unordered.each do |s|
      versions << Version.new(s)
    end

    versions.sort.each_with_index do |version, index|
      version.to_s.should == version_strings_ordered[index]
    end
  end
end
