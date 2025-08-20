module Deepagents
  module Generators
    class ControllerGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('templates', __dir__)
      
      desc "Creates DeepAgents API controllers for your Rails application"
      
      class_option :skip_routes, type: :boolean, default: false, desc: "Skip routes generation"
      class_option :api_version, type: :string, default: "v1", desc: "API version"
      
      def create_controller_file
        template "api_controller.rb", "app/controllers/api/#{options[:api_version]}/#{file_name}_controller.rb"
      end
      
      def create_serializer_file
        template "serializer.rb", "app/serializers/#{file_name}_serializer.rb"
      end
      
      def add_routes
        return if options[:skip_routes]
        
        route_file = "config/routes.rb"
        route_content = <<~ROUTE
          namespace :api do
            namespace :#{options[:api_version]} do
              resources :#{plural_name}, only: [:index, :show, :create] do
                member do
                  post :run
                  post :upload
                end
              end
            end
          end
        ROUTE
        
        inject_into_file route_file, route_content, after: "Rails.application.routes.draw do\n"
      end
      
      def display_next_steps
        say "\n"
        say "DeepAgents API controller for #{file_name} has been created! 🎮", :green
        say "\n"
        say "Next steps:", :yellow
        say "  1. Ensure you have the required models (use the model generator if needed)"
        say "  2. Add any custom API endpoints to your controller"
        say "  3. Test your API endpoints with curl or Postman"
        say "\n"
      end
    end
  end
end
