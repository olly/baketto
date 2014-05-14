require_relative '../s3'

class Baketto::Server
  def initialize(config)
    @config = config
    @fs = S3::FS.new(config.bucket_name, access_key_id: config.aws_access_key_id, secret_access_key: config.aws_secret_access_key)
  end

  def call(env)
    path = Rack::Utils.unescape(env['PATH_INFO'])

    node = fs[path]

    if node.directory?
      context = OpenStruct.new
      context.bucket_name = config.pretty_bucket_name
      context.items = node.items
      context.path = node.path
      body = Mustache.render(directory_template, context)
    
      [200, {'Content-Type' => 'text/html'}, [body]]
    else
      [302, {'Location' => node.url}, []]
    end
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
