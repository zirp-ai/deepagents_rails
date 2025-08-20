module Deepagents
  module Generators
    class ToolGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('templates', __dir__)
      
      desc "Creates a new DeepAgents tool for your Rails application"
      
      class_option :description, type: :string, default: "", desc: "Description of what the tool does"
      class_option :parameters, type: :array, default: [], desc: "Parameters for the tool"
      
      def create_tool_file
        template "tool.rb", "app/deepagents/tools/#{file_name}_tool.rb"
      end
      
      def create_tool_spec_file
        template "tool_spec.rb", "spec/deepagents/tools/#{file_name}_tool_spec.rb"
      end
      
      def display_next_steps
        say "\n"
        say "Tool #{file_name} has been created! 🔧", :green
        say "\n"
        say "Next steps:", :yellow
        say "  1. Edit app/deepagents/tools/#{file_name}_tool.rb to implement your tool's functionality"
        say "  2. Add this tool to your agents by including it in the tools array"
        say "\n"
      end
      
      private
      
      def tool_description
        options[:description].present? ? options[:description] : "Performs #{file_name} operations"
      end
      
      def tool_parameters
        options[:parameters].empty? ? ["query"] : options[:parameters]
      end
      
      def parameters_as_args
        params = tool_parameters
        if params.size == 1
          params.first
        else
          params.join(", ")
        end
      end
      
      def parameters_with_defaults
        params = tool_parameters
        if params.size == 1
          "#{params.first}"
        else
          params.map { |p| "#{p}" }.join(", ")
        end
      end
    end
  end
end
