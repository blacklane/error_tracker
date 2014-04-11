require 'rspec'
require 'error_tracker'

RSpec.configure do |config|
  config.mock_with :rspec
  config.order = "random"
end
