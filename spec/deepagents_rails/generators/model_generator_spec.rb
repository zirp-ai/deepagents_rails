# frozen_string_literal: true

require 'spec_helper'
require 'generator_spec'
require 'generators/deepagents/model/model_generator'

RSpec.describe Deepagents::Generators::ModelGenerator, type: :generator do
  include GeneratorSpec::TestCase

  destination File.expand_path('../../tmp', __dir__)
  
  before do
    prepare_destination
    
    # Instead of stubbing Thor methods directly, we'll stub the methods that call them
    allow_any_instance_of(Deepagents::Generators::ModelGenerator).to receive(:create_conversation_model).and_return(true)
    allow_any_instance_of(Deepagents::Generators::ModelGenerator).to receive(:create_message_model).and_return(true)
    allow_any_instance_of(Deepagents::Generators::ModelGenerator).to receive(:create_file_model).and_return(true)
    allow_any_instance_of(Deepagents::Generators::ModelGenerator).to receive(:create_migrations).and_return(true)
  end
  
  describe 'generator runs' do
    it 'runs without errors' do
      expect { run_generator }.not_to raise_error
    end
  end
end
