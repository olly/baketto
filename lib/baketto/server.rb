require_relative '../s3'

class Baketto::Server
  def initialize(config)
    @config = config
    @fs = S3::FS.new(config.bucket_name, access_key_id: config.aws_access_key_id, secret_access_key: config.aws_secret_access_key)
  end

  def call(env)
    path = env['PATH_INFO']

    context = OpenStruct.new
    context.bucket_name = config.bucket_name
    context.items = fs.files
    body = Mustache.render(directory_template, context)
    
    [200, {'Content-Type' => 'text/html'}, [body]]
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
