Bundler.setup
Bundler.require

require_relative './lib/baketto'

config = Baketto::Config.new(ENV)
app = Baketto::Server.new(config)
app = Baketto::Authentication.new(app, config)

run app
