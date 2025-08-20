# frozen_string_literal: true

class CreateDeepagents<%= class_name.pluralize %>Conversations < ActiveRecord::Migration[6.0]
  def change
    create_table :deepagents_<%= file_name %>_conversations do |t|
      t.string :title
      t.references :user, polymorphic: true, index: { name: 'index_<%= file_name %>_conversations_on_user' }
      t.string :agent_name
      t.jsonb :metadata, default: {}
      
      t.timestamps
    end
    
    add_index :deepagents_<%= file_name %>_conversations, :created_at
  end
end
