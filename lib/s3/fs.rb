class S3::FS
  def initialize(bucket_name, access_key_id:, secret_access_key:)
    @bucket_name, @access_key_id, @secret_access_key = bucket_name, access_key_id, secret_access_key
  end

  def [](key)
    return root if key == '/'

    key = key.sub(%r{^/}, '')
    root[key]
  end

  private
  attr_reader :access_key_id, :bucket_name, :secret_access_key

  def connection
    @connection ||= Fog::Storage.new(provider: 'AWS', aws_access_key_id: access_key_id, aws_secret_access_key: secret_access_key)
  end

  def bucket
    connection.directories.get(bucket_name)
  end

  def root
    @root ||= bucket.files.each_with_object(S3::Directory.new) do |file, root|
      next if file.key.end_with?('/') # skip directories

      filename = File.basename(file.key)
      root[file.key] = S3::File.new(file, name: filename)
    end
  end
end
