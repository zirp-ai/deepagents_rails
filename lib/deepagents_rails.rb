require "deepagents_rails/version"
require "deepagents_rails/service"
require "deepagents"
require "rails"

module DeepagentsRails
  class Engine < ::Rails::Engine
    isolate_namespace DeepagentsRails
    
    config.deepagents = ActiveSupport::OrderedOptions.new
    config.deepagents.api_key = nil
    config.deepagents.model = "claude-3-sonnet-20240229"
    config.deepagents.provider = :claude
    
    initializer "deepagents_rails.configure" do |app|
      # Load configuration from config/initializers/deepagents.rb if it exists
    end
    
    config.to_prepare do
      # Load deepagents tools and agents when the Rails app boots
      Dir.glob(Rails.root.join("app/deepagents/**/*.rb")).sort.each do |file|
        require_dependency file
      end
    end
  end
  
  # Helper method to create a new service instance
  def self.service(agent_name = nil, options = {})
    Service.new(agent_name, options)
  end
end
