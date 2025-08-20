# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DeepagentsRails::Service do
  let(:mock_agent) { instance_double("DeepAgents::Agent") }
  
  before do
    # Mock Rails logger
    allow(Rails).to receive_message_chain(:logger, :warn)
    allow(Rails).to receive_message_chain(:logger, :error)
    
    # Mock Rails.root for file path resolution
    allow(Rails).to receive_message_chain(:root, :join) { |path| path }
    allow(Dir).to receive(:[]).and_return([])
    
    # Create a module structure for our test agents
    module Deepagents; module Agents; end; end
    
    # Create test agent class
    test_agent_class = Class.new do
      def initialize(options = {})
      end
      
      def run(input, context = {})
        { response: "Test response", files: {} }
      end
    end
    
    # Register our test agent class
    Deepagents::Agents.const_set('TestAgentAgent', test_agent_class)
  end
  
  let(:service) { described_class.new(:test_agent) }
  
  describe '#initialize' do
    it 'loads the specified agent' do
      service = described_class.new(:test_agent)
      expect(service.agent).to be_a(Deepagents::Agents::TestAgentAgent)
    end
    
    it 'initializes with default values when no agent is specified' do
      # Create a default agent class
      default_agent_class = Class.new do
        def initialize(options = {}); end
        def run(input, context = {}); end
      end
      Deepagents::Agents.const_set('DefaultAgent', default_agent_class)
      
      service_without_agent = described_class.new(nil)
      expect(service_without_agent.agent).to be_a(Deepagents::Agents::DefaultAgent)
    end
  end
  
  describe '#run' do
    let(:input) { "Hello, agent!" }
    let(:context) { { user_id: 1 } }
    let(:expected_response) { { response: "Test response", files: {} } }
    
    it 'runs the agent with the given input and context' do
      expect(service.run(input, context)).to eq(expected_response)
    end
    
    it 'raises an error if no agent is loaded' do
      # Create a service instance directly
      service_without_agent = described_class.allocate
      
      # Initialize instance variables manually
      service_without_agent.instance_variable_set(:@agent, nil)
      service_without_agent.instance_variable_set(:@config, DeepagentsRails::Engine.config.deepagents)
      service_without_agent.instance_variable_set(:@agent_name, :test)
      service_without_agent.instance_variable_set(:@options, {})
      
      expect { service_without_agent.run(input) }.to raise_error(/No agent loaded/)
    end
  end
  
  describe '#available_tools' do
    # Create a module structure for our test tools
    before do
      module Deepagents; module Tools; end; end
      
      # Create test tool class
      test_tool_class = Class.new do
        def self.build
          "test_tool_instance"
        end
      end
      
      # Register our test tool class
      Deepagents::Tools.const_set('TestTool', test_tool_class)
      
      # Mock directory listing
      allow(Dir).to receive(:[]).with('app/deepagents/tools/**/*_tool.rb').and_return(['app/deepagents/tools/test_tool.rb'])
      allow(File).to receive(:basename).with('app/deepagents/tools/test_tool.rb', '.rb').and_return('test_tool')
      allow(service).to receive(:require)
    end
    
    it 'returns a list of available tools' do
      expect(service.available_tools).to eq(["test_tool_instance"])
    end
  end
  
  describe '#available_agents' do
    before do
      # Mock directory listing
      allow(Dir).to receive(:[]).with('app/deepagents/agents/**/*_agent.rb').and_return(['app/deepagents/agents/test_agent.rb'])
      allow(File).to receive(:basename).with('app/deepagents/agents/test_agent.rb', '.rb').and_return('test_agent')
    end
    
    it 'returns a list of available agent names' do
      expect(service.available_agents).to eq(['test'])
    end
  end
end
