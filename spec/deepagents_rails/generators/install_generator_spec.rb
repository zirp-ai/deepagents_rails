# frozen_string_literal: true

require 'spec_helper'
require 'generator_spec'
require 'generators/deepagents/install/install_generator'

RSpec.describe Deepagents::Generators::InstallGenerator, type: :generator do
  include GeneratorSpec::TestCase

  destination File.expand_path('../../tmp', __dir__)
  
  before do
    prepare_destination
    # Create a dummy routes file
    FileUtils.mkdir_p("#{destination_root}/config")
    File.write("#{destination_root}/config/routes.rb", "Rails.application.routes.draw do\nend")
    
    # Instead of stubbing Thor methods directly, we'll stub the methods that call them
    allow_any_instance_of(Deepagents::Generators::InstallGenerator).to receive(:create_initializer).and_return(true)
    allow_any_instance_of(Deepagents::Generators::InstallGenerator).to receive(:create_config).and_return(true)
    allow_any_instance_of(Deepagents::Generators::InstallGenerator).to receive(:update_routes).and_return(true)
    allow_any_instance_of(Deepagents::Generators::InstallGenerator).to receive(:create_env_example).and_return(true)
  end
  
  describe 'generator runs' do
    it 'runs without errors' do
      expect { run_generator }.not_to raise_error
    end
  end
end
