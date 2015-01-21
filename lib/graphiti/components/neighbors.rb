require 'securerandom'

module Graphiti

  class Neighbors

    attr_accessor :aql, :bind_vars

    def initialize list, options = {}
      @graph_name = Graphiti.config.graph
      @options_name = SecureRandom.hex(6)
      options = options.merge(uniqueness: {edges: "global", vertices: "globals"})
      @aql = "(FOR i IN (#{list.aql}) FOR n IN i RETURN GRAPH_NEIGHBORS(@graph_name, n, @#{@options_name})[*].vertex)"

      @bind_vars = list.bind_vars.merge('graph_name' => @graph_name, @options_name.to_s => options)
    end

    def to_query
      [@aql, @bind_vars]
    end

  end



end

