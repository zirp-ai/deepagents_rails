# frozen_string_literal: true

# DeepAgents Rails configuration
DeepagentsRails::Engine.config.deepagents.tap do |config|
  # API key for your LLM provider (Claude or OpenAI)
  # You can set this via environment variable DEEPAGENTS_API_KEY
  config.api_key = ENV.fetch('DEEPAGENTS_API_KEY', nil)
  
  # LLM provider to use (:claude or :openai)
  # You can set this via environment variable DEEPAGENTS_PROVIDER
  config.provider = ENV.fetch('DEEPAGENTS_PROVIDER', 'claude').to_sym
  
  # Default model to use
  # For Claude: "claude-3-sonnet-20240229", "claude-3-opus-20240229", etc.
  # For OpenAI: "gpt-4o", "gpt-4-turbo", etc.
  config.model = ENV.fetch('DEEPAGENTS_MODEL', 'claude-3-sonnet-20240229')
  
  # Default temperature for LLM requests (0.0 to 1.0)
  config.temperature = ENV.fetch('DEEPAGENTS_TEMPERATURE', '0.7').to_f
  
  # Maximum tokens to generate in responses
  config.max_tokens = ENV.fetch('DEEPAGENTS_MAX_TOKENS', '4096').to_i
  
  # Configure default tools available to all agents
  # config.default_tools = [:calculator, :web_search]
  
  # Configure logging
  config.log_requests = Rails.env.development?
end

# Load custom tools
# Dir[Rails.root.join('app/deepagents/tools/**/*.rb')].each { |file| require file }

# Load custom agents
# Dir[Rails.root.join('app/deepagents/agents/**/*.rb')].each { |file| require file }
