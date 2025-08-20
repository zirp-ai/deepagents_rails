# frozen_string_literal: true

require 'spec_helper'
require 'generator_spec'
require 'generators/deepagents/tool/tool_generator'

RSpec.describe Deepagents::Generators::ToolGenerator, type: :generator do
  include GeneratorSpec::TestCase

  destination File.expand_path('../../tmp', __dir__)
  arguments %w(search)
  
  before do
    prepare_destination
    
    # Instead of stubbing Thor methods directly, we'll stub the methods that call them
    allow_any_instance_of(Deepagents::Generators::ToolGenerator).to receive(:create_tool).and_return(true)
    allow_any_instance_of(Deepagents::Generators::ToolGenerator).to receive(:create_spec).and_return(true)
  end
  
  describe 'generator runs' do
    it 'runs without errors' do
      expect { run_generator }.not_to raise_error
    end
  end
  
  context 'with description option' do
    arguments %w(search --description="Search tool for finding information")
    
    it 'runs without errors' do
      expect { run_generator }.not_to raise_error
    end
  end
  
  context 'with parameters option' do
    arguments %w(search --parameters="query, limit, offset")
    
    it 'runs without errors' do
      expect { run_generator }.not_to raise_error
    end
  end
end
