require 'json'

module Graphiti

  class List
    attr_accessor :aql, :bind_vars

    def initialize items
      @bind_vars = {}
      if items.respond_to? :aql
        # this is a Graphiti object
        @aql = "#{items.aql}"
        @bind_vars.merge items.bind_vars
      else
        # this is a raw value
        @items_name = SecureRandom.hex(6)
        @aql = "([[@#{@items_name}]])"
        @bind_vars = {@items_name => items}
      end
    end

  end

end
