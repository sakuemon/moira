# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rdbdocumentor/version'

Gem::Specification.new do |spec|
  spec.name          = "rdbdocumentor"
  spec.version       = Rdbdocumentor::VERSION
  spec.authors       = ["Tsuyoshi MIYAMOTO"]
  spec.email         = ["sakuemon@gmail.com"]
  spec.description   = %q{RDB table spec generator.}
  spec.summary       = %q{RDB table spec generator}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'erubis'
  spec.add_dependency 'mysql2'
  spec.add_dependency 'thor'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "fakefs"
  spec.add_development_dependency "rspec-html-matchers"
  spec.add_development_dependency "factory_girl"
end
