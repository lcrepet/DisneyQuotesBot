require './config/application'

$stdout.sync = true

logger = Logger.new('log/bot.log', 10, 1024000)
use Rack::CommonLogger, logger

require './app/sinatra'
run DisneyBot
