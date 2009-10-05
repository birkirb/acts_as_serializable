require 'acts_as_serializable'
require 'serializable/xbuilder'
ActiveRecord::Base.send(:include, Serializable)
