require 'ashikawa-core'
require "graphiti/version"
require 'graphiti/builder'
require 'graphiti/configuration'
require 'graphiti/components/neighbors'
require 'graphiti/components/edges'
require 'graphiti/components/filter'
require 'graphiti/components/list'
require 'graphiti/components/query'

module Graphiti

  def self.configure opt
   options = symbolize_keys opt
   @@config = Configuration.new options
   @@graph_name = @@config.graph
    @@db = Ashikawa::Core::Database.new() do |conf|
      conf.url = @@config.url
      conf.database_name = @@config.database_name
      conf.username = @@config.username
      conf.password = @@config.password
    end
    true
  end

  def self.database
    @@db
  end

  def self.config
    @@config
  end

  def self.truncate
    @@db.truncate
  end

  def vertices
    execute("RETURN GRAPH_VERTICES(@graph_name, @example)", {graph_name: @@graph_name, example: self}).first
  end

  def filter options = {}
    @builder ||= Builder.new self
    @builder.filter(options)
    self
  end

  def neighbors options = {}
    @builder ||= Builder.new self
    @builder.neighbors(options)
    self
  end

  def edges options = {}
    @builder ||= Builder.new self
    @builder.edges(options)
    self
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

  # Inserts the hash into the specified collection.
  #    foo = {foo: "bar"}.insert.into :vertices

  # TODO: Ashikawa::Core::Document does not provide internal
  # attributes (such as _id, _key, etc.). That should be changed.
  def into collection
    execute("INSERT @example INTO @@collection LET inserted = NEW RETURN inserted", {:example => self, "@collection" => collection.to_s}).to_a.map(&:to_h)
  end

  def results
    aql, bind_vars = @builder.to_query
    execute(aql, bind_vars).flatten
  end

  private

  def db
    @@db
  end

  def execute query, bindvars
    db.query.execute(query, bind_vars: bindvars).to_a
  end

  def self.symbolize_keys(hash)
    new = {}
    hash.map do |key,value|
      if value.is_a?(Hash)
        value = symbolize_keys(value)
      end
      new[key.to_sym]=value
    end
    return new
  end

end


class Hash
  include Graphiti
end
