# frozen_string_literal: true

require_relative 'lib/riemann/tools/postgresql/version'

Gem::Specification.new do |spec|
  spec.name          = 'riemann-postgresql'
  spec.version       = Riemann::Tools::Postgresql::VERSION
  spec.authors       = ['Pradeep Chhetri']
  spec.email         = ['pradeep.chhetri89@gmail.com']

  spec.summary       = 'PostgreSQL Riemann Client'
  spec.homepage      = 'https://github.com/riemann/riemann-postgresql'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.6.0')

  spec.metadata['allowed_push_host'] = 'https://rubygems.org/'

  spec.metadata['homepage_uri']    = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri']   = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'pg', '>= 0.17.1'
  spec.add_runtime_dependency 'riemann-tools', '>= 0.2.1'

  spec.add_development_dependency 'github_changelog_generator'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-rake'
  spec.add_development_dependency 'rubocop-rspec'
end
