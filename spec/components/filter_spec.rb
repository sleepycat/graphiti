require 'spec_helper'
require 'graphiti'

module Graphiti

  RSpec.describe Filter do

    before(:all) do
      options = {
        url: "http://127.0.0.1:8529",
        database_name: "test",
        username: "",
        password: "",
        graph: "test"
      }
      Graphiti.configure options
    end

    let(:db){ {}.send(:db) }

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
