require 'spec_helper'
require 'pry'
require 'graphiti'

module Graphiti

  RSpec.describe Neighbors do

    let :foo do
      {foo: "bar"}.insert.into :nodes
    end

    let :fizz do
      {fizz: "buzz"}.insert.into :nodes
    end

    before(:each) do
      {_to: foo["_id"], _from: fizz["_id"]}.insert.into :edges
    end

    after(:each) do
      clean_out_db
    end

    it "creates a valid AQL query" do
      results = validate_aql "RETURN #{Neighbors.new(List.new(foo: "bar")).aql}"
      expect(results).to eq true
    end

    it "returns expected results" do
      aql, bind_vars = Neighbors.new(List.new(foo: "bar")).to_query
      results = execute_query("RETURN #{aql}", bind_vars).flatten.first
      expect(results["fizz"]).to eq "buzz"
    end

    it "can be nested" do
      aql = "RETURN #{Neighbors.new(Neighbors.new(List.new(foo: 'bar'))).aql}"
      expect(validate_aql aql ).to eq true
    end

    it "has a proper number of bind vars" do
      aql, bind_vars = Neighbors.new(List.new(foo: "bar"), {}).to_query
      expect(bind_vars.keys.length).to eq 3
    end

  end

end
