require 'spec_helper'

module Graphiti

  RSpec.describe Edges do

    before(:each) do
      {foo: "bar"}.insert.into :vertices
      {fizz: "buzz"}.insert.into :vertices
      {_to: foo["_id"], _from: fizz["_id"]}.insert.into :edges
    end

    after(:each) do
      Graphiti.truncate
    end

    let(:db){ {}.send(:db) }

    let(:foo) do
      {foo: "bar"}.vertices.first
    end

    let(:fizz) do
      {fizz: "buzz"}.vertices.first
    end

    let(:edges){ Edges.new(List.new(foo: "bar")) }

    it "creates a valid AQL query" do
      results = db.query.valid? "RETURN #{edges.aql}"
      expect(results).to eq true
    end

    it "returns the edges for the specified vertex" do
      results = db.query.execute("RETURN #{edges.aql}", bind_vars: edges.bind_vars).to_a.flatten
      expect(results.first["_to"]).to eq foo["_id"]
    end

  end

end
