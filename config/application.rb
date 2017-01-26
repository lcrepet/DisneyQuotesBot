require './config/boot'
Dir.glob('./app/actions/*', &method(:require))
Dir.glob('./app/models/*', &method(:require))
Dir.glob('./app/helpers/*', &method(:require))
Dir.glob('./jobs/*', &method(:require))
Dir.glob('./lib/*.rb', &method(:require))
Dir.glob('./lib/tasks/*.rake', &method(:load))
Dir.glob('./config/initializers/*', &method(:require))
