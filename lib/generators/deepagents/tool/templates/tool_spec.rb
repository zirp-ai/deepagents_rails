# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Deepagents::Tools::<%= class_name %>Tool do
  describe '.build' do
    it 'returns a DeepAgents::Tool instance' do
      tool = described_class.build
      expect(tool).to be_a(DeepAgents::Tool)
      expect(tool.name).to eq('<%= file_name %>')
    end
    
    it 'has the correct description' do
      tool = described_class.build
      expect(tool.description).to eq('<%= tool_description %>')
    end
    
    it 'executes the tool functionality' do
      tool = described_class.build
      # Test with sample parameters - adjust based on your tool's parameters
      result = tool.execute(<% tool_parameters.each_with_index do |param, i| %><%= i > 0 ? ', ' : '' %>'test_<%= param %>'<% end %>)
      expect(result).to be_a(String)
      expect(result).to include('Result of <%= file_name %> operation')
    end
    
    it 'handles errors gracefully' do
      tool = described_class.build
      
      # Mock an error in the tool execution
      allow_any_instance_of(DeepAgents::Tool).to receive(:execute).and_raise(StandardError.new('Test error'))
      
      # The tool should catch the error and return an error message
      expect { tool.execute(<% tool_parameters.each_with_index do |param, i| %><%= i > 0 ? ', ' : '' %>'test_<%= param %>'<% end %>) }.not_to raise_error
    end
  end
end
