module Deepagents
  module Generators
    class ViewGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('templates', __dir__)
      
      desc "Creates DeepAgents UI views for your Rails application"
      
      class_option :skip_javascript, type: :boolean, default: false, desc: "Skip JavaScript file generation"
      class_option :skip_stylesheet, type: :boolean, default: false, desc: "Skip stylesheet file generation"
      
      def create_views
        template "index.html.erb", "app/views/#{file_name.pluralize}/index.html.erb"
        template "show.html.erb", "app/views/#{file_name.pluralize}/show.html.erb"
        template "new.html.erb", "app/views/#{file_name.pluralize}/new.html.erb"
        template "_conversation.html.erb", "app/views/#{file_name.pluralize}/_conversation.html.erb"
        template "_message.html.erb", "app/views/#{file_name.pluralize}/_message.html.erb"
        template "_form.html.erb", "app/views/#{file_name.pluralize}/_form.html.erb"
      end
      
      def create_javascript
        return if options[:skip_javascript]
        
        template "javascript.js", "app/javascript/#{file_name}_chat.js"
        
        append_to_file "app/javascript/packs/application.js", <<~JS
          
          // DeepAgents #{class_name} Chat
          import "../#{file_name}_chat"
        JS
      end
      
      def create_stylesheet
        return if options[:skip_stylesheet]
        
        template "stylesheet.css", "app/assets/stylesheets/#{file_name}_chat.css"
      end
      
      def display_next_steps
        say "\n"
        say "DeepAgents UI views for #{file_name} have been created! 🎨", :green
        say "\n"
        say "Next steps:", :yellow
        say "  1. Ensure you have the required controller (use the controller generator if needed)"
        say "  2. Add the JavaScript to your application.js if using Webpacker"
        say "  3. Customize the views to match your application's design"
        say "\n"
      end
    end
  end
end
