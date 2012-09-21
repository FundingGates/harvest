# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'harvest/version'

Gem::Specification.new do |gem|
  gem.name          = "harvest"
  gem.version       = Harvest::VERSION
  gem.authors       = ["Greggory Rothmeier"]
  gem.email         = ["gregg@highgroove.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.add_dependency 'rest-core'
  gem.add_dependency 'rest-client'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'pry'
    

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
