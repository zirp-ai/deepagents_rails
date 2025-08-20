module Deepagents
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)
      
      desc "Creates a DeepAgents initializer and necessary files for your Rails application"
      
      def create_initializer_file
        template "initializer.rb", "config/initializers/deepagents.rb"
      end
      
      def create_configuration_file
        template "deepagents.yml", "config/deepagents.yml"
      end
      
      def mount_engine
        route "mount DeepagentsRails::Engine => '/deepagents'"
      end
      
      def add_environment_variables
        append_to_file '.env.example', <<~ENV
          
          # DeepAgents configuration
          # DEEPAGENTS_API_KEY=your_api_key_here
          # DEEPAGENTS_PROVIDER=claude # or openai
        ENV
      end
      
      def display_post_install_message
        say "\n"
        say "DeepAgents Rails has been installed! 🎉", :green
        say "\n"
        say "Next steps:", :yellow
        say "  1. Configure your API keys in config/deepagents.yml or through environment variables"
        say "  2. Generate your first agent with: rails g deepagents:agent NAME"
        say "  3. Check out the documentation at https://github.com/cdaviis/deepagents_rails"
        say "\n"
      end
    end
  end
end
