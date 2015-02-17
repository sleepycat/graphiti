require 'spec_helper'

module Graphiti
  RSpec.describe Builder do

    before(:each) do
      edge_from_baz_to_foo
      edge_from_fizz_to_foo
    end

    after(:each) do
      clean_out_db
    end

    let(:edge_from_baz_to_foo) do
      {_to: foo["_id"], type: 'edge_from_baz', _from: baz["_id"]}.insert.into :edges
    end

    let(:edge_from_fizz_to_foo) do
      {_to: foo["_id"], type: 'edge_from_fizz', _from: fizz["_id"]}.insert.into :edges
    end

    let(:foo) do
      {foo: "bar"}.insert.into :nodes
    end

    let(:baz) do
      {baz: "quxx"}.insert.into :nodes
    end

    let(:fizz) do
      {fizz: "buzz"}.insert.into :nodes
    end

    describe "#to_query" do
      it "returns a valid AQL query" do
        builder = Builder.new(foo: "bar")
        builder.neighbors.filter
        aql, bindvars = builder.to_query
        expect(validate_aql aql).to eq true
      end

      it "can be executed" do
        builder = Builder.new(foo: "bar")
        aql, bind_vars = builder.neighbors.filter.to_query
        results = execute_query aql, bind_vars
        expect(results.first).to match_array [baz, fizz]
      end

      it "returns edges" do
        builder = Builder.new(foo: "bar")
        aql, bind_vars = builder.edges.to_query
        results = execute_query(aql, bind_vars).flatten
        expect(results).to match_array [ edge_from_fizz_to_foo, edge_from_baz_to_foo ]
      end

      it "returns filtered edges" do
        builder = Builder.new(foo: "bar")
        aql, bind_vars = builder.edges.filter(type: 'edge_from_baz').to_query
        results = execute_query(aql, bind_vars).flatten
        expect(results.first["type"]).to eq "edge_from_baz"
      end

    end

  end
end
