require 'rubygems'
require 'spec'
require 'rake/gempackagetask'
require 'spec/rake/spectask'
require 'pathname'
 
 
ROOT = Pathname(__FILE__).dirname.expand_path
require ROOT + 'lib/rb-music-theory/version'

RUBY_FORGE_PROJECT = "rb-music-theory"
GEM_AUTHOR = "Chris Bratlien"
GEM_EMAIL = "chrisbratlien@gmail.com"
GEM_NAME = "rb-music-theory"
GEM_CLEAN = ["log", "pkg"]
GEM_EXTRAS = { :has_rdoc => true, :extra_rdoc_files => %w[ README.textile LICENSE TODO ] }
 
PROJECT_NAME = "rb-music-theory"
PROJECT_URL = "http://github.com/chrisbratlien/rb-music-theory/tree/master"
PROJECT_DESCRIPTION = PROJECT_SUMMARY = "This gem models notes, note intervals, scales, and chords"
 
#require ROOT.parent + 'tasks/hoe'
 
task :default => [ :spec ]
 
WIN32 = (RUBY_PLATFORM =~ /win32|mingw|cygwin/) rescue nil
SUDO = WIN32 ? '' : ('sudo' unless ENV['SUDOLESS'])

spec = Gem::Specification.new do |s|
  s.rubyforge_project = RUBY_FORGE_PROJECT
  s.name = GEM_NAME
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.textile", "LICENSE", 'TODO']
  s.summary = PROJECT_SUMMARY
  s.description = PROJECT_DESCRIPTION
  s.author = GEM_AUTHOR
  s.email = GEM_EMAIL
  s.homepage = PROJECT_URL
  s.require_path = 'lib'
  s.files = %w(LICENSE README.textile Rakefile TODO) + Dir.glob("{lib,spec}/**/*")
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end
 
desc "Install #{GEM_NAME} #{GEM_VERSION} (default ruby)"
task :install do
  sh "#{SUDO} gem install --local pkg/#{GEM_NAME}-#{GEM_VERSION} --no-update-sources", :verbose => false
end
  
desc "Uninstall #{GEM_NAME} #{GEM_VERSION} (default ruby)"
task :uninstall => [ :clobber ] do
  sh "#{SUDO} gem uninstall #{GEM_NAME} -v#{GEM_VERSION} -I -x", :verbose => false
end
 
namespace :jruby do
  desc "Install #{GEM_NAME} #{GEM_VERSION} with JRuby"
  task :install do
    sh %{#{SUDO} jruby -S gem install --local pkg/#{GEM_NAME}-#{GEM_VERSION} --no-update-sources}, :verbose => false
  end
end
 
desc 'Run specifications'
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_opts << '--options' << 'spec/spec.opts' if File.exists?('spec/spec.opts')
  t.spec_files = Pathname.glob((ROOT + 'spec/**/*_spec.rb').to_s)
 
  begin
    t.rcov = ENV.has_key?('NO_RCOV') ? ENV['NO_RCOV'] != 'true' : true
    t.rcov_opts << '--exclude' << 'spec'
    t.rcov_opts << '--text-summary'
    t.rcov_opts << '--sort' << 'coverage' << '--sort-reverse'
  rescue Exception
    # rcov not installed
  end
end
