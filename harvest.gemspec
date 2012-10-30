# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'harvest/version'

Gem::Specification.new do |gem|
  gem.name          = "harvest-oauth2"
  gem.version       = Harvest::VERSION
  gem.authors       = ["Greggory Rothmeier"]
  gem.email         = ["gregg@highgroove.com"]
  gem.description   = %q{Wrapper for the Harvest API}
  gem.summary       = %q{Wrapper for the Harvest API}
  gem.homepage      = "https://github.com/FundingGates/harvest"

  gem.add_dependency 'rest-client'
  gem.add_dependency 'rest-core'
  gem.add_dependency 'json'
  gem.add_dependency 'activesupport'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'vcr'
  gem.add_development_dependency 'webmock'
    

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
