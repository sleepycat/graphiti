require 'spec_helper'

module Graphiti
  RSpec.describe Builder do

    before(:each) do
      {_to: foo["_id"], type: 'edge_from_fizz', _from: fizz["_id"]}.insert.into :edges
      {_to: foo["_id"], type: 'edge_from_baz', _from: baz["_id"]}.insert.into :edges
    end

    after(:each) do
      Graphiti.truncate
    end

    let(:foo) do
      {foo: "bar"}.insert.into :vertices
      {foo: "bar"}.vertices.first
    end

    let(:baz) do
      {baz: "quxx"}.insert.into :vertices
      {baz: "quxx"}.vertices.first
    end

    let(:fizz) do
      {fizz: "buzz"}.insert.into :vertices
      {fizz: "buzz"}.vertices.first
    end

    let(:db){ {}.send(:db) }

    describe "#to_query" do
      it "returns a valid AQL query" do
        builder = Builder.new(foo: "bar")
        builder.neighbors.filter
        aql, bindvars = builder.to_query
        expect(db.query.valid? aql).to eq true
      end

      it "can be executed" do
        builder = Builder.new(foo: "bar")
        aql, bind_vars = builder.neighbors.filter.to_query
        results = db.query.execute aql, bind_vars: bind_vars
        expect(results.to_a.first).to match_array [baz, fizz]
      end

      it "returns edges" do
        builder = Builder.new(foo: "bar")
        aql, bind_vars = builder.edges.to_query
        results = db.query.execute(aql, bind_vars: bind_vars).to_a.flatten
        expect(results.first["type"]).to eq "edge_from_fizz"
      end

      it "returns filtered edges" do
        builder = Builder.new(foo: "bar")
        aql, bind_vars = builder.edges.filter(type: 'edge_from_baz').to_query
        results = db.query.execute(aql, bind_vars: bind_vars).to_a.flatten
        expect(results.first["type"]).to eq "edge_from_baz"
      end

    end

  end
end
