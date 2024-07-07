# frozen_string_literal: true

require 'riemann/tools/postgresql/version'
require 'bundler/gem_tasks'
require 'github_changelog_generator/task'

GitHubChangelogGenerator::RakeTask.new :changelog do |config|
  config.user = 'riemann'
  config.project = 'riemann-postgresql'
  config.exclude_labels = ['skip-changelog']
  config.future_release = "v#{Riemann::Tools::Postgresql::VERSION}"
end
