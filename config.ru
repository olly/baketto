Bundler.setup
Bundler.require

require_relative './lib/baketto'

config = Baketto::Config.new(ENV)
run Baketto::Server.new(config)
