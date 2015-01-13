require 'spec_helper'
require 'pry'
require 'graphiti'

module Graphiti

  RSpec.describe Neighbors do

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

    before(:each) do
      {foo: "bar"}.insert.into :vertices
      foo = {foo: "bar"}.vertices.first
      {fizz: "buzz"}.insert.into :vertices
      fizz = {fizz: "buzz"}.vertices.first
      {_to: foo["_id"], _from: fizz["_id"]}.insert.into :edges
    end

    after(:each) do
      Graphiti.truncate
    end

    it "creates a valid AQL query" do
      results = db.query.valid? "RETURN #{Neighbors.new(List.new(foo: "bar")).aql}"
      expect(results).to eq true
    end

    it "returns expected results" do
      aql, bind_vars = Neighbors.new(List.new(foo: "bar")).to_query
      results = db.query.execute("RETURN #{aql}", bind_vars: bind_vars).to_a.flatten.first
      expect(results["fizz"]).to eq "buzz"
    end

    it "can be nested" do
      aql = "RETURN #{Neighbors.new(Neighbors.new(List.new(foo: 'bar'))).aql}"
      expect(db.query.valid? aql ).to eq true
    end

    it "has a proper number of bind vars" do
      aql, bind_vars = Neighbors.new(List.new(foo: "bar"), {}).to_query
      expect(bind_vars.keys.length).to eq 3
    end

  end

end
