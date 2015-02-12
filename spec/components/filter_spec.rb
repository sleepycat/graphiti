require 'spec_helper'
require 'graphiti'

module Graphiti

  RSpec.describe Filter do

    it "creates a valid AQL statement" do
      results = validate_aql "RETURN #{Filter.new(List.new(foo: "bar")).aql}"
      expect(results).to eq true
    end

    it "returns expected results" do
      aql, bind_vars = Filter.new(List.new({fizz: "buzz"}), {fizz: "buzz"}).to_query
      results = execute_query("RETURN #{aql}", bind_vars).flatten.first
      expect(results["fizz"]).to eq "buzz"
    end

  end

end
