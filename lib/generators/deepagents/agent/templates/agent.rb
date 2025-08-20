# frozen_string_literal: true

module Deepagents
  module Agents
    class <%= class_name %>Agent
      attr_reader :model, :tools, :subagents
      
      def initialize(options = {})
        # Initialize the model based on configuration
        provider = options[:provider] || DeepagentsRails::Engine.config.deepagents.provider
        model_name = options[:model] || DeepagentsRails::Engine.config.deepagents.model
        api_key = options[:api_key] || DeepagentsRails::Engine.config.deepagents.api_key
        
        @model = case provider.to_sym
                 when :claude
                   DeepAgents::Models::Claude.new(api_key: api_key, model: model_name)
                 when :openai
                   DeepAgents::Models::OpenAI.new(api_key: api_key, model: model_name)
                 else
                   DeepAgents::Models::MockModel.new(model: model_name)
                 end
        
        # Initialize tools
        @tools = setup_tools(options[:tools] || [])
        
        # Initialize subagents
        @subagents = setup_subagents(options[:subagents] || [])
        
        # Create the deep agent
        @agent = create_agent
      end
      
      def run(input, context = {})
        # Run the agent with the given input and context
        result = @agent.invoke({
          messages: [{role: "user", content: input}],
          files: context[:files] || {}
        })
        
        # Return the result
        {
          response: result.messages.last[:content],
          files: result.files
        }
      end
      
      private
      
      def setup_tools(tool_names)
        tools = []
        
        # Add default tools
        tools << DeepAgents::Tool.new(
          "calculator",
          "Perform mathematical calculations"
        ) do |expression|
          begin
            eval(expression).to_s
          rescue => e
            "Error: #{e.message}"
          end
        end
        
        # Add custom tools based on tool_names
        # Implement your custom tools here
        
        tools
      end
      
      def setup_subagents(subagent_configs)
        subagents = []
        
        # Add custom subagents based on subagent_configs
        # Implement your custom subagents here
        
        subagents
      end
      
      def create_agent
        # Define the agent's instructions
        instructions = <<~INSTRUCTIONS
          You are a helpful assistant named <%= class_name %>.
          
          Your primary goal is to assist users with their questions and tasks.
          
          Please be concise, accurate, and helpful in your responses.
        INSTRUCTIONS
        
        # Create and return the deep agent
        DeepAgents.create_deep_agent(
          @tools,
          instructions,
          model: @model,
          subagents: @subagents
        )
      end
    end
  end
end
