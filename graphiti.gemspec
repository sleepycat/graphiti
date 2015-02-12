# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'graphiti/version'

Gem::Specification.new do |spec|
  spec.name          = "graphiti"
  spec.version       = Graphiti::VERSION
  spec.authors       = ["Mike Williamson"]
  spec.email         = ["mike@korora.ca"]
  spec.license       = 'MIT'
  spec.summary       = "A library to work with graphs in Arangodb"
  spec.description   = "Work more easily with graphs when using Arangodb"
  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "faraday", "~> 0.9"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry", "~> 0.9"
end
