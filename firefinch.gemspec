# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'firefinch/version'

Gem::Specification.new do |gem|
  gem.name          = "firefinch"
  gem.version       = Firefinch::VERSION
  gem.authors       = ["SAITO Jun"]
  gem.email         = ["jsaito@xopowo.info"]
  gem.description   = %q{A TeX preprocessor with Ruby}
  gem.summary       = %q{A TeX preprocessor with Ruby}
  gem.homepage      = "https://github.com/st63jun/firefinch"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_development_dependency('rdoc')
  gem.add_development_dependency('aruba')
  gem.add_development_dependency('rake', '~> 0.9.2')
  gem.add_dependency('methadone', '~> 1.2.4')
end
