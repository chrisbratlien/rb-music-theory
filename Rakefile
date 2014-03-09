require 'rubygems'
require 'rspec'
require 'rake/packagetask'
require 'rspec/core/rake_task'
require 'pathname'

load './rb-music-theory.gemspec'

#require ROOT.parent + 'tasks/hoe'
 
task :default => [ :spec ]
 
WIN32 = (RUBY_PLATFORM =~ /win32|mingw|cygwin/) rescue nil
SUDO = WIN32 ? '' : ('sudo' unless ENV['SUDOLESS'])

Rake::PackageTask.new(SPEC, GEM_VERSION)
 
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
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = '--options spec/spec.opts' if File.exists?('spec/spec.opts')
  #t.files = Pathname.glob((ROOT + 'spec/**/*_spec.rb').to_s)
end
