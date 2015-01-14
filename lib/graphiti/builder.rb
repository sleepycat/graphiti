module Graphiti
  class Builder

    def initialize value
      @stack = []
      @value = List.new value
    end

    def neighbors options = {}
      @stack << [Neighbors, options]
      self
    end

    def edges options = {}
      @stack << [Edges, options]
      self
    end

    def filter options = {}
      @stack << [Filter, options]
      self
    end

    def to_query
      #TODO clarify this:
      # call to neighbors.filter gives us
      # Filter.new(Neighbors.new(List.new))
      result = @stack.inject(@value){|v, e| e[0].new(v, e[1]) }
      # pass result to a Query Node:
      finished_query = Query.new(result)
      [finished_query.aql, finished_query.bind_vars]
    end

  end
end
