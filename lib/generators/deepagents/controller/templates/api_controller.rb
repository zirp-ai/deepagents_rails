# frozen_string_literal: true

module Api
  module <%= options[:api_version].camelize %>
    class <%= class_name %>Controller < ApplicationController
      before_action :set_conversation, only: [:show, :run, :upload]
      
      # GET /api/<%= options[:api_version] %>/<%= plural_name %>
      def index
        @conversations = Deepagents::<%= class_name %>Conversation.recent.limit(20)
        
        render json: @conversations, each_serializer: <%= class_name %>Serializer
      end
      
      # GET /api/<%= options[:api_version] %>/<%= plural_name %>/:id
      def show
        render json: @conversation, serializer: <%= class_name %>Serializer, include: ['messages', 'files']
      end
      
      # POST /api/<%= options[:api_version] %>/<%= plural_name %>
      def create
        @conversation = Deepagents::<%= class_name %>Conversation.new(conversation_params)
        
        if @conversation.save
          # Add a system message if provided
          if params[:system_message].present?
            @conversation.<%= file_name %>_messages.create!(
              role: 'system',
              content: params[:system_message]
            )
          end
          
          render json: @conversation, serializer: <%= class_name %>Serializer, status: :created
        else
          render json: { errors: @conversation.errors }, status: :unprocessable_entity
        end
      end
      
      # POST /api/<%= options[:api_version] %>/<%= plural_name %>/:id/run
      def run
        input = params[:input]
        agent_name = params[:agent_name]
        
        if input.blank?
          render json: { error: 'Input is required' }, status: :unprocessable_entity
          return
        end
        
        result = @conversation.run_agent(input, agent_name)
        
        render json: {
          message: result[:message],
          files: result[:files]
        }
      end
      
      # POST /api/<%= options[:api_version] %>/<%= plural_name %>/:id/upload
      def upload
        if params[:file].blank?
          render json: { error: 'File is required' }, status: :unprocessable_entity
          return
        end
        
        file = params[:file]
        
        @file = @conversation.<%= file_name %>_files.create!(
          filename: file.original_filename,
          content: file.read
        )
        
        render json: @file
      end
      
      private
      
      def set_conversation
        @conversation = Deepagents::<%= class_name %>Conversation.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Conversation not found' }, status: :not_found
      end
      
      def conversation_params
        params.require(:<%= file_name %>).permit(:title, :agent_name, metadata: {})
      end
    end
  end
end
