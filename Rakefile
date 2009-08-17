require 'rubygems'
require 'rake'
require 'rake/testtask'

task :default => ["test:all"]

namespace "test" do
  desc "Run the tests"
  Rake::TestTask.new(:all) do |t|
    t.libs << "test"
    t.test_files = FileList['test/test*.rb']
    t.verbose = true
  end
end
