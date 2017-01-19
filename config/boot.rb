require 'rubygems'
require 'bundler'

require 'dotenv'
Dotenv.load

ENV['RACK_ENV'] ||= 'development'
Bundler.require(:default, ENV['RACK_ENV']) # Set up gems listed in the Gemfile.
