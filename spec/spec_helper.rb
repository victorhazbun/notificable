require "bundler/setup"
require "notificable"
require "wisper/rspec/matchers"
require "wisper/rspec/stub_wisper_publisher"

RSpec.configure do |config|
  config.include(Wisper::RSpec::BroadcastMatcher)
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
