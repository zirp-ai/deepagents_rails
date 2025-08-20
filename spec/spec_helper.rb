# frozen_string_literal: true

require 'bundler/setup'
require 'deepagents_rails'
require 'rails'
require 'action_controller/railtie'
require 'action_view/railtie'
require 'active_record/railtie'
require 'generator_spec'

# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

# Create a dummy Rails application for testing
module Dummy
  class Application < Rails::Application
    config.eager_load = false
    config.active_support.deprecation = :stderr
    config.secret_key_base = 'test_key_base'
  end
end

Dummy::Application.initialize!

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  
  # Clean up generated files after tests
  config.after(:all) do
    FileUtils.rm_rf(Dir["tmp/[^.]*"])
  end
end
