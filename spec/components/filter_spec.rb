require 'spec_helper'
require 'graphiti'

module Graphiti

  RSpec.describe Filter do

    let(:db){ Graphiti.database }

    it "creates a valid AQL statement" do
      results = db.query.valid? "RETURN #{Filter.new(List.new(foo: "bar")).aql}"
      expect(results).to eq true
    end

    it "returns expected results" do
      aql, bind_vars = Filter.new(List.new({fizz: "buzz"}), {fizz: "buzz"}).to_query
      results = db.query.execute("RETURN #{aql}", bind_vars: bind_vars).to_a.flatten.first
      expect(results["fizz"]).to eq "buzz"
    end

  end

end
