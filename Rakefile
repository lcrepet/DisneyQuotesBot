require File.expand_path('../config/application', __FILE__)

require 'rake/testtask'
Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = false
  t.warning = false
end

require 'sinatra/activerecord'
require "sinatra/activerecord/rake"
namespace :db do
  task :load_config do
    require "clarke"
    require "clarke/messenger"
    require 'sinatra'
    require "./app/sinatra"
  end
end
