module Graphiti

  class Query

    attr_accessor :aql, :bind_vars

    def initialize statement
      @aql = "RETURN #{statement.aql}"
      @bind_vars = statement.bind_vars
    end
  end
end
