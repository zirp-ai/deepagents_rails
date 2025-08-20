# frozen_string_literal: true

module DeepagentsRails
  # Service class for interacting with DeepAgents in a Rails application
  class Service
    attr_reader :agent, :config
    
    # Initialize a new DeepAgents service
    # @param agent_name [Symbol, String] The name of the agent to use
    # @param options [Hash] Additional options for the agent
    def initialize(agent_name = nil, options = {})
      @config = DeepagentsRails::Engine.config.deepagents
      @agent_name = agent_name || :default
      @options = options
      
      # Load the agent if specified
      load_agent if @agent_name
    end
    
    # Run the agent with the given input
    # @param input [String] The input to send to the agent
    # @param context [Hash] Additional context for the agent
    # @return [Hash] The agent's response
    def run(input, context = {})
      ensure_agent_loaded
      
      # Run the agent
      @agent.run(input, context)
    end
    
    # Get a list of available tools
    # @return [Array<DeepAgents::Tool>] The available tools
    def available_tools
      tools = []
      
      # Load tools from the Rails app
      Dir[Rails.root.join('app/deepagents/tools/**/*_tool.rb')].each do |file|
        require file
        
        # Extract the tool class name from the file path
        tool_name = File.basename(file, '.rb').gsub('_tool', '')
        tool_class_name = tool_name.camelize
        
        # Try to load the tool class
        begin
          tool_class = "Deepagents::Tools::#{tool_class_name}Tool".constantize
          tools << tool_class.build if tool_class.respond_to?(:build)
        rescue NameError => e
          Rails.logger.warn("Could not load tool class for #{tool_name}: #{e.message}")
        end
      end
      
      tools
    end
    
    # Get a list of available agents
    # @return [Array<String>] The available agent names
    def available_agents
      agents = []
      
      # Load agents from the Rails app
      Dir[Rails.root.join('app/deepagents/agents/**/*_agent.rb')].each do |file|
        # Extract the agent name from the file path
        agent_name = File.basename(file, '.rb').gsub('_agent', '')
        agents << agent_name
      end
      
      agents
    end
    
    private
    
    # Load the specified agent
    def load_agent
      agent_class_name = @agent_name.to_s.camelize
      
      begin
        agent_class = "Deepagents::Agents::#{agent_class_name}Agent".constantize
        @agent = agent_class.new(@options)
      rescue NameError => e
        Rails.logger.error("Could not load agent class for #{@agent_name}: #{e.message}")
        raise "Agent not found: #{@agent_name}"
      end
    end
    
    # Ensure that an agent is loaded
    def ensure_agent_loaded
      if @agent.nil?
        raise "No agent loaded. Please specify an agent name when initializing the service."
      end
    end
  end
end
