require_relative '../s3'

class Baketto::Server
  def initialize(config)
    @config = config
    @fs = S3::FS.new(config.bucket_name, access_key_id: config.aws_access_key_id, secret_access_key: config.aws_secret_access_key)
  end

  def call(env)
    path = Rack::Utils.unescape(env['PATH_INFO'])

    node = fs[path]

    if node && node.directory?
      context = OpenStruct.new
      context.host = config.host
      context.items = node.items
      context.path = node.path
      body = Mustache.render(directory_template, context)
    
      [200, {'Content-Type' => 'text/html'}, [body]]
    elsif node
      [302, {'Location' => node.url}, []]
    else
      body = templates_path.join('404.html').read
      [404, {'Content-Type' => 'text/html'}, [body]]
    end
  rescue
    body = templates_path.join('500.html').read
    [500, {'Content-Type' => 'text/html'}, [body]]
  end

  private
  attr_reader :config, :fs

  def templates_path
    @templates_path ||= Pathname.new(__dir__).join('..', '..', 'templates').expand_path
  end

  def directory_template
    @directory_template ||= templates_path.join('directory.html.mustache').read
  end
end
