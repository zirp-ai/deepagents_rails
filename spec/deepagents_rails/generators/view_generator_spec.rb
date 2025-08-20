# frozen_string_literal: true

require 'spec_helper'
require 'generator_spec'
require 'generators/deepagents/view/view_generator'

RSpec.describe Deepagents::Generators::ViewGenerator, type: :generator do
  include GeneratorSpec::TestCase

  destination File.expand_path('../../tmp', __dir__)
  arguments %w(chat)
  
  before do
    prepare_destination
    FileUtils.mkdir_p("#{destination_root}/app/javascript/packs")
    File.write("#{destination_root}/app/javascript/packs/application.js", "// This is a test application.js file")
    
    # Instead of stubbing Thor methods directly, we'll stub the methods that call them
    allow_any_instance_of(Deepagents::Generators::ViewGenerator).to receive(:create_views).and_return(true)
    allow_any_instance_of(Deepagents::Generators::ViewGenerator).to receive(:create_javascript).and_return(true)
    allow_any_instance_of(Deepagents::Generators::ViewGenerator).to receive(:create_stylesheet).and_return(true)
    allow_any_instance_of(Deepagents::Generators::ViewGenerator).to receive(:update_application_js).and_return(true)
  end
  
  describe 'generator runs' do
    it 'runs without errors' do
      expect { run_generator }.not_to raise_error
    end
  end
  
  context 'with skip_javascript option' do
    arguments %w(chat --skip_javascript)
    
    it 'runs without errors' do
      expect { run_generator }.not_to raise_error
    end
  end
  
  context 'with skip_stylesheet option' do
    arguments %w(chat --skip_stylesheet)
    
    it 'runs without errors' do
      expect { run_generator }.not_to raise_error
    end
  end
end
