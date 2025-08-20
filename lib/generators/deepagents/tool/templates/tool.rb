# frozen_string_literal: true

module Deepagents
  module Tools
    class <%= class_name %>Tool
      # Returns a DeepAgents::Tool instance
      def self.build
        DeepAgents::Tool.new(
          "<%= file_name %>",
          "<%= tool_description %>"
        ) do |<%= parameters_with_defaults %>|
          # Implement your tool's functionality here
          # This block will be called when the agent uses this tool
          
          begin
            # Example implementation - replace with your actual logic
            "Result of <%= file_name %> operation with parameters: #{[<%= parameters_as_args %>].join(', ')}"
          rescue => e
            "Error in <%= file_name %> tool: #{e.message}"
          end
        end
      end
      
      # Optional: Add helper methods for your tool below
    end
  end
end
