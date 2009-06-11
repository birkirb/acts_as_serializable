require 'lib/acts_as_serializable'
ActiveRecord::Base.send(:include, Serializable)
