require 'base64'
require 'faraday'
require 'graphiti/version'
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
    @@conn = Faraday.new(:url => @@config.url) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
    @@collections = get_collections

    true
  end

  def self.config
    @@config
  end

  def self.truncate
    @@collections.each do |collection|
      # PUT /_api/collection/{collection-name}/truncate
      @@conn.put "/_db/#{@@config.database_name}/_api/collection/#{collection}/truncate"
    end
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
    execute("FOR i IN @@collection FILTER MATCHES(i, @example) REMOVE i IN @@collection LET removed = OLD RETURN removed", {:example => self, "@collection" => collection.to_s}).first
  end

  def insert
    self
  end

  # Inserts the hash into the specified collection.
  #    foo = {foo: "bar"}.insert.into :vertices
  def into collection
    execute("INSERT @example INTO @@collection LET inserted = NEW RETURN inserted", {:example => self, "@collection" => collection.to_s}).first
  end

  def results
    aql, bind_vars = @builder.to_query
    execute(aql, bind_vars).first
  end

  private

  def self.get_collections
    # GET /_api/collection
    res = JSON.parse(@@conn.get("/_db/#{@@config.database_name}/_api/collection", {excludeSystem: true}).body)
    res["names"].keys
  end

  def conn
    @@conn
  end

  def execute query, bindvars
    res = @@conn.post do |req|
      req.url "/_db/#{@@config.database_name}/_api/cursor"
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Basic #{Base64.encode64("#{@@config.username}:#{@@config.password}")}"
      req.body = { query: query, bindVars: bindvars }.to_json
    end

    JSON.parse(res.body)["result"]
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
