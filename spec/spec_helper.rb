require 'rubygems'

::RAILS_ROOT = File.join(File.dirname(__FILE__))
$LOAD_PATH.push(File.join(::RAILS_ROOT, 'app'))

require 'lib/serializable/version'
require 'lib/serializable/versions'
require 'lib/acts_as_serializable'
