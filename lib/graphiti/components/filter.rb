module Graphiti
  class Filter

    attr_accessor :aql, :bind_vars

    def initialize list, example = {}
      @example_name = SecureRandom.hex(6)
      @aql = "(FOR i IN (#{list.aql}) FOR f IN i FILTER MATCHES(f, @#{@example_name}) RETURN f)"
      @bind_vars = list.bind_vars.merge(@example_name.to_s => example)
    end

    def to_query
      [@aql, @bind_vars]
    end

  end
end
