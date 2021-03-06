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

  def aws_region
    env['AWS_REGION']
  end

  def bucket_name
    env['BUCKET_NAME']
  end

  def host
    env['HOST'] || bucket_name
  end

  def secret_key
    @secret_key ||= env['SECRET_KEY'] || SecureRandom.hex
  end

  def username
    env['AUTH_USER']
  end

  def password
    env['AUTH_PASSWORD']
  end

  private
  attr_reader :env
end
