require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the acts_as_voteable plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the acts_as_voteable plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'ActsAsVoteable'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

PKG_FILES = FileList['[a-zA-Z]*', 'generators/**/*', 'lib/**/*', 'rails/**/*', 'tasks/**/*', 'test/**/*']

spec = Gem::Specification.new do |s|
  s.name = "acts_as_voteable"
  s.version = "0.0.1"
  s.author = "Roman Scherer"
  s.email = "roman.scherer@gmx.de"
  s.homepage = "http://github.com/r0man/acts_as_voteable"
  s.platform = Gem::Platform::RUBY
  s.summary = "Voting support for Active Record models."
  s.files = PKG_FILES.to_a
  s.require_path = "lib"
  s.has_rdoc = false
end

desc 'Turn this plugin into a gem.'
Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end
