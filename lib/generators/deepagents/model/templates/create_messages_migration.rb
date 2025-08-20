# frozen_string_literal: true

class CreateDeepagents<%= class_name.pluralize %>Messages < ActiveRecord::Migration[6.0]
  def change
    create_table :deepagents_<%= file_name %>_messages do |t|
      t.references :conversation, null: false, foreign_key: { to_table: :deepagents_<%= file_name %>_conversations }, index: { name: 'index_<%= file_name %>_messages_on_conversation_id' }
      t.string :role, null: false
      t.text :content, null: false
      t.jsonb :metadata, default: {}
      
      t.timestamps
    end
    
    add_index :deepagents_<%= file_name %>_messages, :created_at
    add_index :deepagents_<%= file_name %>_messages, :role
  end
end
