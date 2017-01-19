ENV['RACK_ENV'] = 'test'

require 'test/unit'
require 'test/unit/context'
require 'rack/test'
require 'factory_girl'
require 'vcr'

VCR.configure do |config|
  puts 'VCR configured'
  config.allow_http_connections_when_no_cassette = true
  config.hook_into :webmock
  config.cassette_library_dir = "test/fixtures/vcr_cassettes"
end

class Test::Unit::TestCase
  include FactoryGirl::Syntax::Methods
  FactoryGirl.find_definitions
end

require './config/application'
require './app/sinatra'

