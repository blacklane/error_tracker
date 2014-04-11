# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'error_tracker/version'

Gem::Specification.new do |spec|
  spec.name = "error_tracker"
  spec.version = ErrorTracker::VERSION
  spec.authors = ["Florin LIPAN", "Blacklane"]
  spec.email = ["technology@blacklane.com"]
  spec.description = %q{Unified error tracking.}
  spec.summary = %q{Provides hooks for a unified error tracking system.}
  spec.homepage = "https://www.blacklane.com"

  spec.files = `git ls-files`.split($/)
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  # Development
  spec.add_development_dependency "rake"

  # Testing
  spec.add_development_dependency "rspec"

  # Production
  spec.add_dependency "activesupport", ">= 3.0"
  spec.add_dependency "request_store", "~> 1.0.3"
end
