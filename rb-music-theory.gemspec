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

SPEC = Gem::Specification.new do |s|
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

  s.add_development_dependency "rspec"
  s.add_development_dependency "rake"
  #s.add_development_dependency "rcov"
end
