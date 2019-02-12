require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/testtask'

desc "Run tests"
task default: 'test'

Rake::TestTask.new do |t|
  t.libs << 'tests'
  t.test_files = FileList['tests/test_*.rb']
  # Load SimpleCov before starting the tests
  t.ruby_opts = ['-r "./tests/test_helper"']
  t.verbose = true
end

Dir['tasks/**/*.rake'].each { |t| load t }
