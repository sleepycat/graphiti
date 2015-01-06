require 'ashikawa-core'
require "graphiti/version"

module Graphiti

  def self.configure options
    @@graph_name = options[:graph]
    @@db = Ashikawa::Core::Database.new() do |conf|
      conf.url = options[:url]
      conf.database_name = options[:database_name]
      conf.username = options[:username]
      conf.password = options[:password]
    end
    true
  end


  def vertices
    execute("RETURN GRAPH_VERTICES(@graph_name, @example)", {graph_name: @@graph_name, example: self}).first
  end

  def edges
    execute("RETURN GRAPH_EDGES(@graph_name, @example)", {graph_name: @@graph_name, example: self}).first
  end

  def neighbors options = {}
    execute("RETURN GRAPH_NEIGHBORS(@graph_name, @example, @options)", {graph_name: @@graph_name, example: self, options: options}).first
  end

  def remove
    self
  end

  def from(collection)
    execute "FOR i IN @@collection FILTER MATCHES(i, @example) REMOVE i IN @@collection", {:example => self, "@collection" => collection.to_s}
  end

  def insert
    self
  end

  def into collection
    execute "INSERT @example INTO @@collection", {:example => self, "@collection" => collection.to_s}
  end

  private

  def db
    @@db
  end

  def execute query, bindvars
    db.query.execute(query, bind_vars: bindvars).to_a
  end

end


class Hash
  include Graphiti
end
