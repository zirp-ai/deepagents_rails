# frozen_string_literal: true

module Deepagents
  class <%= class_name %>Message < ApplicationRecord
    self.table_name = 'deepagents_<%= file_name %>_messages'
    
    belongs_to :<%= file_name %>_conversation, class_name: 'Deepagents::<%= class_name %>Conversation', foreign_key: 'conversation_id'
    
    # Alias for easier access
    alias_method :conversation, :<%= file_name %>_conversation
    
    # Validations
    validates :role, presence: true, inclusion: { in: %w[user assistant system] }
    validates :content, presence: true
    
    # Scopes
    scope :user, -> { where(role: 'user') }
    scope :assistant, -> { where(role: 'assistant') }
    scope :system, -> { where(role: 'system') }
    scope :chronological, -> { order(created_at: :asc) }
    
    # Convert to format expected by DeepAgents
    def to_agent_format
      {
        role: role,
        content: content
      }
    end
  end
end
