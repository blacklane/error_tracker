# -*- encoding: utf-8 -*-
# stub: error_tracker 0.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "error_tracker"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Florin LIPAN", "Blacklane"]
  s.date = "2016-03-11"
  s.description = "Unified error tracking."
  s.email = ["technology@blacklane.com"]
  s.files = [".gitignore", "Gemfile", "README.md", "Rakefile", "error_tracker.gemspec", "lib/error_tracker.rb", "lib/error_tracker/adapter.rb", "lib/error_tracker/context.rb", "lib/error_tracker/notifier.rb", "lib/error_tracker/railtie.rb", "lib/error_tracker/version.rb", "spec/lib/error_tracker_spec.rb", "spec/spec_helper.rb"]
  s.homepage = "https://www.blacklane.com"
  s.rubygems_version = "2.2.2"
  s.summary = "Provides hooks for a unified error tracking system."
  s.test_files = ["spec/lib/error_tracker_spec.rb", "spec/spec_helper.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 3.0"])
      s.add_runtime_dependency(%q<request_store>, ["~> 1.0.3"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<activesupport>, [">= 3.0"])
      s.add_dependency(%q<request_store>, ["~> 1.0.3"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<activesupport>, [">= 3.0"])
    s.add_dependency(%q<request_store>, ["~> 1.0.3"])
  end
end
