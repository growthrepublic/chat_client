lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'growth_republic_chat_client/version'

Gem::Specification.new do |spec|
  spec.name          = "growth_republic_chat_client"
  spec.version       = GrowthRepublicChatClient::VERSION
  spec.authors       = ["Artur Hebda"]
  spec.email         = ["arturhebda@gmail.com"]
  spec.summary       = %[Client for Growth Republic's chat application API.]
  spec.description   = %[
    This gem wraps Chat API with easy to use models created by Her.
    It passes pagination details received from the Chat API using Kaminari.]
  spec.homepage      = "https://github.com/growthrepublic/chat_client"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "her"
  spec.add_runtime_dependency "faraday"
  spec.add_runtime_dependency "faraday_middleware"
  spec.add_runtime_dependency "kaminari"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0.0.rc1"
  spec.add_development_dependency "rspec-mocks", "~> 3.0.0.rc1"
  spec.add_development_dependency "webmock"
end
