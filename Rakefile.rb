require 'rubygems'
require 'rubygems/package_task'
require 'rdoc/task'
require 'find'

# Don't include resource forks in tarballs on Mac OS X.
ENV['COPY_EXTENDED_ATTRIBUTES_DISABLE'] = 'true'
ENV['COPYFILE_DISABLE'] = 'true'

# Gemspec
gemspec = Gem::Specification.new do |s|
  s.rubyforge_project = 'riemann-postgresql'

  s.name = 'riemann-postgresql'
  s.version = '0.1.1'
  s.author = 'Pradeep Chhetri'
  s.email = 'pradeep.chhetri89@gmail.com'
  s.homepage = 'https://github.com/riemann/riemann-postgresql'
  s.platform = Gem::Platform::RUBY
  s.summary = 'PostgreSQL Riemann Client'

  s.add_dependency 'riemann-tools', '>= 0.2.1'

  s.files = FileList['bin/*', 'LICENSE', 'README.md'].to_a
  s.executables |= Dir.entries('bin/')
  s.has_rdoc = false

  s.required_ruby_version = '>= 2.0.0'
end

Gem::PackageTask.new gemspec do |p|
end

RDoc::Task.new do |rd|
  rd.main = 'Riemann PostgreSQL'
  rd.title = 'Riemann PostgreSQL'
  rd.rdoc_dir = 'doc'
end
