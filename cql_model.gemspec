# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cql/model/version'

Gem::Specification.new do |spec|
  spec.name          = 'cql_model'
  spec.version       = Cql::Model::VERSION
  spec.authors       = ['James Thompson']
  spec.email         = %w{james@plainprograms.com'}
  spec.description   = %q{An ActiveModel implementation on top of the cql-rb gem}
  spec.summary       = %q{ActiveModel implementation on cql-rb}
  spec.homepage      = 'http://plainprogrammer.github.io/cql_model/'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w{lib}

  spec.add_dependency 'cql-rb', '~> 1.0'
  spec.add_dependency 'activemodel', '~> 4.0.0.rc1'
  spec.add_dependency 'activesupport', '~> 4.0.0.rc1'

  spec.add_development_dependency 'minitest', '~> 4.2.0'
  spec.add_development_dependency 'simplecov', '~> 0.7.1'
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
