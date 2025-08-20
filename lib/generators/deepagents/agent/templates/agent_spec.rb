# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Deepagents::Agents::<%= class_name %>Agent do
  let(:agent) { described_class.new(provider: :mock) }
  
  describe '#initialize' do
    it 'creates an agent with the correct model' do
      expect(agent.model).to be_a(DeepAgents::Models::MockModel)
    end
    
    it 'sets up the required tools' do
      expect(agent.tools).not_to be_empty
      expect(agent.tools.first).to be_a(DeepAgents::Tool)
    end
  end
  
  describe '#run' do
    it 'returns a response when given input' do
      result = agent.run('Hello, how are you?')
      expect(result).to be_a(Hash)
      expect(result[:response]).to be_a(String)
    end
    
    it 'handles file context' do
      result = agent.run('What is in the file?', files: { 'test.txt' => 'This is a test file.' })
      expect(result).to be_a(Hash)
      expect(result[:response]).to be_a(String)
      expect(result[:files]).to be_a(Hash)
    end
  end
end
