require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'ci/reporter/rake/minitest'

desc "Run tests"
task default: 'test'

Rake::TestTask.new do |t|
  t.libs << 'tests'
  t.test_files = FileList['tests/test_*.rb']
  t.verbose = true
end

Dir['tasks/**/*.rake'].each { |t| load t }

task :report => ['ci:setup:minitest', 'test']