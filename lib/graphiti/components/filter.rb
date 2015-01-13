module Graphiti
  class Filter

    attr_accessor :aql, :bind_vars

    def initialize list, example = {}
      @example_name = SecureRandom.hex(6)
      # TODO: revisit this.
      # Really it should be the responsiblity of each component to make
      # sure it emits a flat list of documents so that other components
      # can work with them. Unfortunately its kind of tricky to actually
      # do it. So for now it seems like the way to go is flatten stuff
      # on the way in. :(
      @aql = "(FOR i IN FLATTEN(#{list.aql}) FILTER MATCHES(i, @#{@example_name}) RETURN i)"
      @bind_vars = list.bind_vars.merge(@example_name.to_s => example)
    end

    def to_query
      [@aql, @bind_vars]
    end

  end
end
