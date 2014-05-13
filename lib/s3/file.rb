class S3::File
  def initialize(file, name:)
    @name = name
    @file = file
  end

  attr_reader :name

  def path
    "/#{file.key}"
  end

  def url
    expires_at = (Time.now + 60 * 60).to_i
    file.url(expires_at)
  end

  def directory?
    false
  end

  private
  attr_reader :file
end
