require 'rubygems'

::RAILS_ROOT = File.join(File.dirname(__FILE__))
$LOAD_PATH.push(File.join(::RAILS_ROOT, 'app'))

require 'serializable/version'
require 'serializable/versions'
require 'acts_as_serializable'

def silence_warnings
  begin
    old_verbose, $VERBOSE = $VERBOSE, nil
    yield
  ensure
    $VERBOSE = old_verbose
  end
end
