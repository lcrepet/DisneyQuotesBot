Dir.glob('./app/request_builders/*', &method(:require))
Dir.glob('./app/actions/*', &method(:require))

Clarke::RequestsBuilder.config([
  Clarke::RequestsBuilder::Help
])
