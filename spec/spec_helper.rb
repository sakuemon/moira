require "rubygems"
require "rspec"
require "factory_girl"
require 'fakefs/spec_helpers'

Dir[File.join(File.dirname(__FILE__), "..", "lib", "**/*.rb")].each{|f| require f}

FactoryGirl.definition_file_paths = [
        File.join(File.dirname(__FILE__), 'factories')
]
FactoryGirl.find_definitions

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include FakeFS::SpecHelpers, fakefs: true
end
