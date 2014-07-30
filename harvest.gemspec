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

  gem.add_dependency 'rest-client', '~> 1.7.2'
  gem.add_dependency 'rest-core', '~> 2.0.0'
  gem.add_dependency 'json', '~> 1.7.7'
  gem.add_dependency 'activesupport'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rake', '~> 10.0'
  gem.add_development_dependency 'rspec', '~> 2.0'
  gem.add_development_dependency 'vcr'
  gem.add_development_dependency 'webmock'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
