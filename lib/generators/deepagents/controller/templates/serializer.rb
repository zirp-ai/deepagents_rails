# frozen_string_literal: true

class <%= class_name %>Serializer < ActiveModel::Serializer
  attributes :id, :title, :agent_name, :metadata, :created_at, :updated_at
  
  has_many :<%= file_name %>_messages, serializer: <%= class_name %>MessageSerializer
  has_many :<%= file_name %>_files, serializer: <%= class_name %>FileSerializer
  
  # Add any custom serialization logic here
end

class <%= class_name %>MessageSerializer < ActiveModel::Serializer
  attributes :id, :role, :content, :metadata, :created_at
end

class <%= class_name %>FileSerializer < ActiveModel::Serializer
  attributes :id, :filename, :content, :metadata, :created_at, :url
  
  def url
    object.url if object.respond_to?(:url)
  end
end
