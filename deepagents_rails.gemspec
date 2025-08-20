require_relative "lib/deepagents_rails/version"

Gem::Specification.new do |spec|
  spec.name        = "deepagents_rails"
  spec.version     = DeepagentsRails::VERSION
  spec.authors     = ["Chris Davis"]
  spec.email       = ["chrisdavis179@gmail.com"]
  spec.homepage    = "https://github.com/cdaviis/deepagents_rails"
  spec.summary     = "Rails integration for DeepAgents"
  spec.description = "Easily add deep agent capabilities to your Rails application with generators and integrations"
  spec.license     = "MIT"
  
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/cdaviis/deepagents_rails"
  spec.metadata["changelog_uri"] = "https://github.com/cdaviis/deepagents_rails/blob/main/CHANGELOG.md"
  spec.metadata["documentation_uri"] = "https://github.com/cdaviis/deepagents_rails/blob/main/README.md"

  spec.files = Dir.glob("{app,config,db,lib}/**/*") + ["LICENSE", "README.md"]
  
  spec.required_ruby_version = ">= 3.0.0"

  spec.add_dependency "rails", "~> 6.0", ">= 6.0.0"
  spec.add_dependency "deepagents", "~> 0.1", ">= 0.1.0"
end
