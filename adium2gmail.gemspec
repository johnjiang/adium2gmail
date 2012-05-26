# -*- encoding: utf-8 -*-
require File.expand_path('../lib/Adium2Gmail/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["John Jiang"]
  gem.email         = ["johnjiang101@gmail.com"]
  gem.description   = %q{Write a gem description}
  gem.summary       = %q{Write a gem summary}
  gem.homepage      = ""

  gem.add_dependency('mail')
  gem.add_dependency('nokogiri')
  gem.add_dependency('trollop')

  gem.add_development_dependency('rspec')

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "adium2gmail"
  gem.require_paths = ["lib"]
  gem.version       = Adium2Gmail::VERSION
end
