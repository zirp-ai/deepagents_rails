module Deepagents
  module Generators
    class AgentGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('templates', __dir__)
      
      desc "Creates a new DeepAgents agent for your Rails application"
      
      class_option :tools, type: :array, default: [], desc: "Tools to include with this agent"
      class_option :model, type: :string, desc: "Model to use for this agent (claude, openai, etc.)"
      class_option :subagents, type: :array, default: [], desc: "Subagents to include with this agent"
      
      def create_agent_file
        template "agent.rb", "app/deepagents/agents/#{file_name}_agent.rb"
      end
      
      def create_agent_spec_file
        template "agent_spec.rb", "spec/deepagents/agents/#{file_name}_agent_spec.rb"
      end
      
      def create_agent_controller
        template "controller.rb", "app/controllers/deepagents/#{file_name}_controller.rb"
      end
      
      def create_agent_views
        template "index.html.erb", "app/views/deepagents/#{file_name}/index.html.erb"
        template "show.html.erb", "app/views/deepagents/#{file_name}/show.html.erb"
      end
      
      def update_routes
        route "namespace :deepagents do\n    resources :#{file_name}, only: [:index, :show, :create]\n  end"
      end
      
      def display_next_steps
        say "\n"
        say "Agent #{file_name} has been created! 🤖", :green
        say "\n"
        say "Next steps:", :yellow
        say "  1. Edit app/deepagents/agents/#{file_name}_agent.rb to customize your agent"
        say "  2. Add any custom tools in app/deepagents/tools/"
        say "  3. Access your agent at /deepagents/#{file_name}"
        say "\n"
      end
      
      private
      
      def model_name
        options[:model] || "DeepagentsRails::Engine.config.deepagents.provider"
      end
      
      def tools_list
        options[:tools].empty? ? "[]" : options[:tools].map { |t| ":#{t}" }.join(", ")
      end
    end
  end
end
