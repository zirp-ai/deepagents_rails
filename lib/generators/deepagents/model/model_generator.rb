module Deepagents
  module Generators
    class ModelGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('templates', __dir__)
      
      desc "Creates DeepAgents models for your Rails application"
      
      def create_conversation_model
        template "conversation.rb", "app/models/deepagents/#{file_name}_conversation.rb"
      end
      
      def create_message_model
        template "message.rb", "app/models/deepagents/#{file_name}_message.rb"
      end
      
      def create_file_model
        template "file.rb", "app/models/deepagents/#{file_name}_file.rb"
      end
      
      def create_migrations
        template "create_conversations_migration.rb", "db/migrate/#{timestamp}_create_deepagents_#{file_name}_conversations.rb"
        template "create_messages_migration.rb", "db/migrate/#{timestamp(1)}_create_deepagents_#{file_name}_messages.rb"
        template "create_files_migration.rb", "db/migrate/#{timestamp(2)}_create_deepagents_#{file_name}_files.rb"
      end
      
      def display_next_steps
        say "\n"
        say "DeepAgents models for #{file_name} have been created! 📚", :green
        say "\n"
        say "Next steps:", :yellow
        say "  1. Run migrations with: rails db:migrate"
        say "  2. Use the models in your agents and controllers"
        say "\n"
      end
      
      private
      
      def timestamp(offset = 0)
        Time.now.utc.strftime("%Y%m%d%H%M%S").to_i + offset
      end
    end
  end
end
