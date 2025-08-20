# DeepAgents for Rails

DeepAgents Rails is a Ruby on Rails integration for the [DeepAgents](https://github.com/zirp-ai/deepagents) gem, providing easy setup and scaffolding for adding AI agent capabilities to your Rails applications.

## Features

- **Rails Integration**: Seamlessly integrate DeepAgents with your Rails application
- **Generators**: Quickly scaffold agents, tools, models, controllers, and views
- **UI Components**: Pre-built UI for agent conversations
- **API Endpoints**: Ready-to-use API endpoints for agent interactions
- **Database Models**: Store and retrieve conversation history
- **File Handling**: Upload and process files with your agents

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'deepagents_rails'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install deepagents_rails
```

Then run the installation generator:

```bash
$ rails generate deepagents:install
```

This will:
- Create a configuration file at `config/deepagents.yml`
- Create an initializer at `config/initializers/deepagents.rb`
- Mount the DeepAgents Rails engine in your routes
- Add environment variable examples to `.env.example`

## Configuration

After installation, you can configure DeepAgents Rails in `config/initializers/deepagents.rb`:

```ruby
# config/initializers/deepagents.rb
DeepagentsRails::Engine.config.deepagents.tap do |config|
  config.api_key = ENV['DEEPAGENTS_API_KEY']
  config.provider = ENV['DEEPAGENTS_PROVIDER']&.to_sym || :claude
  config.model = ENV['DEEPAGENTS_MODEL'] || 'claude-3-sonnet-20240229'
  config.temperature = ENV['DEEPAGENTS_TEMPERATURE']&.to_f || 0.7
  config.max_tokens = ENV['DEEPAGENTS_MAX_TOKENS']&.to_i || 2000
end
```

You can also use the YAML configuration file at `config/deepagents.yml`:

```yaml
# config/deepagents.yml
default: &default
  provider: claude
  model: claude-3-sonnet-20240229
  temperature: 0.7
  max_tokens: 2000

development:
  <<: *default
  api_key: <%= ENV['DEEPAGENTS_API_KEY'] %>

test:
  <<: *default
  provider: mock
  api_key: test_key

production:
  <<: *default
  api_key: <%= ENV['DEEPAGENTS_API_KEY'] %>
```

## Usage

### Creating an Agent

Generate a new agent with:

```bash
$ rails generate deepagents:agent research
```

This will create:
- An agent class at `app/deepagents/agents/research_agent.rb`
- A controller at `app/controllers/researches_controller.rb`
- Views at `app/views/researches/`
- A test file at `spec/deepagents/agents/research_agent_spec.rb`
- Routes for the agent

You can then customize your agent:

```ruby
# app/deepagents/agents/research_agent.rb
module Deepagents
  module Agents
    class ResearchAgent
      def initialize(options = {})
        @model = DeepAgents::Models::Claude.new(
          api_key: DeepagentsRails::Engine.config.deepagents.api_key,
          model: DeepagentsRails::Engine.config.deepagents.model
        )
        @agent = DeepAgents::Agent.new(@model)
        setup_tools
        setup_subagents
      end

      def setup_tools
        # Add your tools here
        @agent.add_tool(Deepagents::Tools::SearchTool.build)
      end

      def setup_subagents
        # Add your subagents here
      end

      def run(input, context = {})
        @agent.run(input, context)
      end
    end
  end
end
```

### Creating a Tool

Generate a new tool with:

```bash
$ rails generate deepagents:tool search --description="Search for information" --parameters=query,limit
```

This will create:
- A tool class at `app/deepagents/tools/search_tool.rb`
- A test file at `spec/deepagents/tools/search_tool_spec.rb`

You can then customize your tool:

```ruby
# app/deepagents/tools/search_tool.rb
module Deepagents
  module Tools
    class SearchTool
      def self.build
        DeepAgents::Tool.new(
          "search",
          "Search for information"
        ) do |query, limit|
          # Implement your tool's functionality here
          # This block will be called when the agent uses this tool
          
          begin
            # Example implementation
            "Found #{limit || 10} results for: #{query}"
          rescue => e
            "Error in search tool: #{e.message}"
          end
        end
      end
    end
  end
end
```

### Creating Models for Conversation Storage

Generate models for storing conversations:

```bash
$ rails generate deepagents:model chat
```

This will create:
- Models at `app/models/deepagents/chat_conversation.rb`, `app/models/deepagents/chat_message.rb`, and `app/models/deepagents/chat_file.rb`
- Migrations for creating the necessary tables

Run the migrations:

```bash
$ rails db:migrate
```

You can then use these models to store and retrieve conversations:

```ruby
# Create a new conversation
conversation = Deepagents::ChatConversation.create!(title: "My Chat")

# Add a system message
conversation.chat_messages.create!(role: "system", content: "You are a helpful assistant.")

# Add a user message
conversation.chat_messages.create!(role: "user", content: "Hello!")

# Run the agent with the conversation context
result = conversation.run_agent("Tell me about Ruby on Rails")

# Access the assistant's response
puts result[:message].content
```

### Creating API Endpoints

Generate API controllers for your agents:

```bash
$ rails generate deepagents:controller chat --api_version=v1
```

This will create:
- An API controller at `app/controllers/api/v1/chat_controller.rb`
- Serializers at `app/serializers/chat_serializer.rb`
- Routes for the API endpoints

You can then use these endpoints to interact with your agents:

```
GET /api/v1/chats          # List conversations
GET /api/v1/chats/:id      # Get a conversation
POST /api/v1/chats         # Create a conversation
POST /api/v1/chats/:id/run # Run the agent
```

### Creating UI Components

Generate UI views for your agents:

```bash
$ rails generate deepagents:view chat
```

This will create:
- Views at `app/views/chats/`
- JavaScript at `app/javascript/chat_chat.js`
- CSS at `app/assets/stylesheets/chat_chat.css`

You can then access the UI at:

```
GET /chats          # List conversations
GET /chats/:id      # View a conversation
GET /chats/new      # Create a new conversation
```

## Service Integration

You can use the DeepAgents Rails service to interact with your agents:

```ruby
# Get a service instance with the default agent
service = DeepagentsRails.service

# Get a service instance with a specific agent
service = DeepagentsRails.service(:research)

# Run the agent
result = service.run("Tell me about Ruby on Rails")

# Get available tools
tools = service.available_tools

# Get available agents
agents = service.available_agents
```

## Testing

DeepAgents Rails includes a mock provider for testing:

```ruby
# config/environments/test.rb
config.deepagents.provider = :mock
```

You can then test your agents without making actual API calls:

```ruby
# spec/deepagents/agents/research_agent_spec.rb
RSpec.describe Deepagents::Agents::ResearchAgent do
  it "returns a response" do
    agent = described_class.new
    result = agent.run("Tell me about Ruby on Rails")
    expect(result[:response]).to include("Ruby on Rails")
  end
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).