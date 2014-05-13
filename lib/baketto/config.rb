class Baketto::Config
  def initialize(env)
    @env = env
  end

  def aws_access_key_id
    env['AWS_ACCESS_KEY_ID']
  end

  def aws_secret_access_key
    env['AWS_SECRET_ACCESS_KEY']
  end

  def bucket_name
    env['BUCKET_NAME']
  end

  private
  attr_reader :env
end
