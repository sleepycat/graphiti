module Graphiti
  class Edges

    attr_accessor :aql, :bind_vars

    def initialize example, options = {}
      @graph_name = Graphiti.config.graph
      @options_name = SecureRandom.hex(6)
      @aql = "(FOR i IN FLATTEN(#{example.aql}) RETURN GRAPH_EDGES(@graph_name, i, @#{@options_name}))"

      @bind_vars = example.bind_vars.merge('graph_name' => @graph_name, @options_name.to_s => options)
    end

  end
end
