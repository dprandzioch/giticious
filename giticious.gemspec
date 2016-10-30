# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'giticious/version'

Gem::Specification.new do |spec|
  spec.name          = 'giticious'
  spec.version       = Giticious::VERSION
  spec.authors       = ['David Prandzioch']
  spec.email         = ['hello@davd.eu']
  spec.summary       = %q{Giticious is a simple Git server with user management}
  spec.description   = ''
  spec.homepage      = 'https://github.com/dprandzioch/giticious'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = ['giticious']
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'

  spec.add_dependency 'terminal-table', '~> 1.4'
  spec.add_dependency 'thor', '~> 0.19'
  spec.add_dependency 'sqlite3', '~> 1.3'
  spec.add_dependency 'activerecord', '~> 4.2'
end
