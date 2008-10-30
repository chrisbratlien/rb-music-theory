require 'rubygems'
require 'rake/gempackagetask'
require "extlib"
require 'merb-core/tasks/merb_rake_helper'
require "spec/rake/spectask"

##############################################################################
# Package && release
##############################################################################
RUBY_FORGE_PROJECT  = "cb-music-theory"
PROJECT_URL         = "http://chrisbratlien.com"
PROJECT_SUMMARY     = "Basic music theory classes"
PROJECT_DESCRIPTION = PROJECT_SUMMARY

GEM_AUTHOR = "Chris Bratlien"
GEM_EMAIL  = "chrisbratlien@gmail.com"

GEM_NAME    = "cb-music-theory"
PKG_BUILD   = ENV['PKG_BUILD'] ? '.' + ENV['PKG_BUILD'] : ''
GEM_VERSION = "0.1"

RELEASE_NAME    = "REL #{GEM_VERSION}"

#require "extlib/tasks/release"

spec = Gem::Specification.new do |s|
  s.rubyforge_project = RUBY_FORGE_PROJECT
  s.name = GEM_NAME
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README", "LICENSE", 'TODO']
  s.summary = PROJECT_SUMMARY
  s.description = PROJECT_DESCRIPTION
  s.author = GEM_AUTHOR
  s.email = GEM_EMAIL
  s.homepage = PROJECT_URL
  s.add_dependency('merb-core', '>= 0.9.9')
  s.require_path = 'lib'
  s.files = %w(LICENSE README Rakefile TODO) + Dir.glob("{lib,spec}/**/*")
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "Install the gem"
task :install do
  Merb::RakeHelper.install(GEM_NAME, :version => GEM_VERSION)
end

desc "Uninstall the gem"
task :uninstall do
  Merb::RakeHelper.uninstall(GEM_NAME, :version => GEM_VERSION)
end

desc "Create a gemspec file"
task :gemspec do
  File.open("#{GEM_NAME}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end

desc "Run all examples (or a specific spec with TASK=xxxx)"
Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_opts  = ["-cfs"]
  t.spec_files = begin
    if ENV["TASK"] 
      ENV["TASK"].split(',').map { |task| "spec/**/#{task}_spec.rb" }
    else
      FileList['spec/**/*_spec.rb']
    end
  end
end

desc 'Default: run spec examples'
task :default => 'spec'
