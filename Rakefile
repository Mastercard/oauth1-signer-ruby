require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/testtask'

task default: "test"

desc "Run tests"

Rake::TestTask.new do |t|
  t.libs << 'tests'
  t.test_files = FileList['tests/test_*.rb']
  t.verbose = true
end