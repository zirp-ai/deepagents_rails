# frozen_string_literal: true

module Deepagents
  class <%= class_name %>Controller < ApplicationController
    before_action :initialize_agent
    
    def index
      # Display the agent interface
    end
    
    def show
      # Display a specific conversation
      @conversation = Conversation.find(params[:id])
    end
    
    def create
      # Process user input and get agent response
      @input = params[:input]
      
      # Get any file attachments
      files = {}
      if params[:files].present?
        params[:files].each do |file|
          files[file.original_filename] = file.read
        end
      end
      
      # Run the agent
      result = @agent.run(@input, files: files)
      
      # Return the response
      respond_to do |format|
        format.html { redirect_to deepagents_<%= file_name %>_path, notice: "Response generated" }
        format.json { render json: result }
      end
    end
    
    private
    
    def initialize_agent
      @agent = Deepagents::Agents::<%= class_name %>Agent.new
    end
  end
end
