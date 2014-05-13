class S3::FS
  def initialize(bucket, access_key_id:, secret_access_key:)
    @bucket, @access_key_id, @secret_access_key = bucket, access_key_id, secret_access_key
  end

  def files
    root.files.map {|file| S3::File.new(file) }
  end

  private
  attr_reader :access_key_id, :bucket, :secret_access_key

  def connection
    @connection ||= Fog::Storage.new(provider: 'AWS', aws_access_key_id: access_key_id, aws_secret_access_key: secret_access_key)
  end

  def root
    connection.directories.get(bucket)
  end
end
