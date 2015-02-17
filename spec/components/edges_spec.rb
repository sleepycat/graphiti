require 'spec_helper'

module Graphiti

  RSpec.describe Edges do

    before(:each) do
      {foo: "bar"}.insert.into :nodes
      {fizz: "buzz"}.insert.into :nodes
      {_to: foo["_id"], _from: fizz["_id"]}.insert.into :edges
    end

    after(:each) do
      clean_out_db
    end

    let(:foo) do
      {foo: "bar"}.vertices.first
    end

    let(:fizz) do
      {fizz: "buzz"}.vertices.first
    end

    let(:edges){ Edges.new(List.new(foo: "bar")) }

    it "creates a valid AQL query" do
      results = validate_aql "RETURN #{edges.aql}"
      expect(results).to eq true
    end

    it "returns the edges for the specified vertex" do
      results = execute_query("RETURN #{edges.aql}", edges.bind_vars).flatten
      expect(results.first["_to"]).to eq foo["_id"]
    end

  end

end
