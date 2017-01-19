Dir.glob('./app/sinatra/routes/*', &method(:require))
Dir.glob('./app/helpers/*', &method(:require))
require './app/clarke'

puts "Clarke version : #{Clarke::VERSION}"
puts "ClarkeMessenger version : #{Clarke::Messenger::VERSION}"

class NexityAgent_Bot < Sinatra::Base
  configure :production, :development do
    enable :logging
  end

  enable :sessions
  set :protection, :except => [:json_csrf]

  Clarke::Messenger::Config.facebook_page_token = ENV['FB_PAGE_TOKEN']

  get '/messenger' do
    if params['hub.verify_token'] == ENV['MESSENGER_VERIFY_TOKEN']
      params['hub.challenge']
    else
      'Error, wrong validation token.'
    end
  end

  post '/messenger' do
    request_body = JSON.parse(request.body.read)
    responses = Clarke.process(Clarke::Messenger, request_body)
    responses.to_s
  end
end
