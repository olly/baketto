class Baketto::Authentication
  def initialize(app, config)
    @app = app
    @config = config
  end

  def call(env)
    auth.call(env)
  end

  private
  attr_reader :app, :config

  def auth
    @auth ||= Rack::Auth::Digest::MD5.new(app, realm: config.pretty_bucket_name, opaque: config.secret_key) do |username|
      {config.username => config.password}[username]
    end
  end
end
