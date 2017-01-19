require 'active_record'

db_options = YAML.load(File.read('./config/database.yml'))
ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || db_options)
