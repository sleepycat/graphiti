class Configuration

  attr_accessor :url, :database_name, :username, :password, :graph

  def initialize options
    @url = options[:url]
    @database_name = options[:database_name]
    @username = options[:username]
    @password = options[:password]
    @graph = options[:graph]
  end

end
