class S3::Directory
  def initialize(parent = nil, name: '')
    @parent = parent
    @name = name
    @files = {}
  end

  attr_reader :name

  def [](key)
    components = key.split('/')

    components.reduce(self) do |directory, component|
      directory.files[component]
    end
  end

  def []=(key, value)
    components = key.split('/')
    filename = components.pop

    directory = components.reduce(self) do |directory, component|
      directory[component] ||= S3::Directory.new(directory, name: component)
      directory[component]
    end

    directory.files[filename] = value
  end

  def path
    components = []
    node = self

    loop do
      components.unshift(node.name)
      node = node.parent
      break if node.nil?
    end

    components.join('/')
  end

  def items
    files.values
  end

  def directory?
    true
  end

  protected
  attr_reader :files, :parent
end
