require 'spec/spec_helper'

module ActionView
	class TemplateHandler
	end

	module TemplateHandlers
		module Compilable
		end
	end

	class Template
		def self.register_template_handler(*args)
		end
	end
end

module Rails
	module VERSION
		def self.set(val)
			const_set(:MAJOR, val)
		end
	end
end

def set_rails(version)
	Rails::VERSION.set(version)
	if defined?(Serializable::XBuilder)
		Serializable.send(:remove_const, "XBuilder")
		xbuilder_path = $".detect { |lib| lib =~ /xbuilder/ }
		$".delete(xbuilder_path)
	end
	require 'lib/serializable/xbuilder'
end

describe "XBuilder", 'when in Rails' do
  context 'and Rails is version 2' do
    it 'should inherit from ActionView::TemplateHandler' do
    	set_rails(2)
    	Serializable::XBuilder.ancestors.include?(ActionView::TemplateHandler).should be_true
    end
  	it 'should include Compilable' do
  		set_rails(2)
  		Serializable::XBuilder.ancestors.include?(ActionView::TemplateHandlers::Compilable).should be_true
  	end
  end

  context 'and Rails is version 3' do
  	it 'should not inherit from ActionView::TemplateHandler' do
  		set_rails(3)
  		Serializable::XBuilder.ancestors.include?(ActionView::TemplateHandler).should be_false
  	end

  	it 'should not include Compilable' do
  		set_rails(3)
  		Serializable::XBuilder.ancestors.include?(ActionView::TemplateHandlers::Compilable).should be_false
  	end
  end
end