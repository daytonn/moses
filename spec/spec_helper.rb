$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'moses'
require 'pry'
require 'pry-nav'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|

  def fixture(file)
    File.join(File.expand_path("../", __FILE__), "fixtures", file)
  end

  def fixture_content(file)
    File.read(fixture(file))
  end
end
