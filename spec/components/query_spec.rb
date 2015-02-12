require 'pry'
require 'spec_helper'
require 'graphiti'

module Graphiti

  RSpec.describe Query do

    it "creates a valid AQL query" do
      results = validate_aql Query.new(List.new(foo: "bar")).aql
      expect(results).to eq true
    end

  end

end
