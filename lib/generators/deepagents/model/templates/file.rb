# frozen_string_literal: true

module Deepagents
  class <%= class_name %>File < ApplicationRecord
    self.table_name = 'deepagents_<%= file_name %>_files'
    
    belongs_to :<%= file_name %>_conversation, class_name: 'Deepagents::<%= class_name %>Conversation', foreign_key: 'conversation_id'
    
    # Alias for easier access
    alias_method :conversation, :<%= file_name %>_conversation
    
    # Validations
    validates :filename, presence: true
    validates :content, presence: true
    
    # Get the file extension
    def extension
      File.extname(filename).delete('.')
    end
    
    # Check if the file is an image
    def image?
      %w[jpg jpeg png gif svg webp].include?(extension.downcase)
    end
    
    # Check if the file is a text file
    def text?
      %w[txt md markdown rb py js html css json yaml yml xml].include?(extension.downcase)
    end
    
    # Generate a URL for the file (if using Active Storage)
    def url
      if defined?(ActiveStorage) && attachment.present?
        Rails.application.routes.url_helpers.rails_blob_path(attachment, only_path: true)
      else
        "#"
      end
    end
    
    # Attach the file content to Active Storage (if available)
    def attach_content
      return unless defined?(ActiveStorage)
      
      # Create a tempfile with the content
      tempfile = Tempfile.new([filename, ".#{extension}"])
      tempfile.binmode
      tempfile.write(content)
      tempfile.rewind
      
      # Attach the tempfile
      attachment.attach(
        io: tempfile,
        filename: filename,
        content_type: content_type
      )
      
      # Close and delete the tempfile
      tempfile.close
      tempfile.unlink
    end
    
    private
    
    # Determine the content type based on the extension
    def content_type
      case extension.downcase
      when 'jpg', 'jpeg'
        'image/jpeg'
      when 'png'
        'image/png'
      when 'gif'
        'image/gif'
      when 'svg'
        'image/svg+xml'
      when 'txt'
        'text/plain'
      when 'md', 'markdown'
        'text/markdown'
      when 'html'
        'text/html'
      when 'css'
        'text/css'
      when 'js'
        'application/javascript'
      when 'json'
        'application/json'
      when 'yaml', 'yml'
        'application/yaml'
      when 'xml'
        'application/xml'
      else
        'application/octet-stream'
      end
    end
  end
end
