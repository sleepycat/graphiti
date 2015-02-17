require 'pry'
require 'spec_helper'
require 'graphiti'

RSpec.describe Graphiti do

  describe ".configure" do

    let(:options) do
      {
        url: "http://127.0.0.1:8529",
        database_name: "test",
        username: "",
        password: "",
        graph: "test"
      }
    end

    let(:options_with_string_keys) do
      {
        'url' => 'http://127.0.0.1:8529',
        'database_name' => 'test',
        'username' => '',
        'password' => '',
        'graph' => 'test'
      }
    end

    it "accepts configuration" do
      expect(Graphiti.configure(options)).to eq true
    end

    it "handles string keys" do
      expect{
        Graphiti.configure(options_with_string_keys)
      }.not_to raise_error
    end

  end

  describe ".query" do

    it "runs an arbitrary query on the current database, and returns the raw json" do
      results = Graphiti.query "RETURN {}", {}
      expect(JSON.parse(results)).to include "result" => [{}]
    end

  end

  describe '.truncate' do

    it 'deletes the current database by truncation' do
      {foo: "bar"}.insert.into :nodes
      Graphiti.truncate
      expect({foo: "bar"}.vertices.length).to eq 0
    end

  end

  describe ".config" do

    it "returns a configuration object" do
      expect(Graphiti.config).to be_a Configuration
    end

  end

  describe "instance methods" do

    before(:each) do
      edge_to_foo_from_baz
      edge_to_foo_from_fizz
      edge_to_asdf_from_baz
    end

    let(:edge_to_asdf_from_baz) do
      {_to: asdf["_id"], type: "edge_to_asdf_from_baz", _from: baz["_id"]}.insert.into :edges
    end

    let(:edge_to_foo_from_baz) do
      {_to: foo["_id"], type: "edge_to_foo_from_baz", _from: baz["_id"]}.insert.into :edges
    end

    let(:edge_to_foo_from_fizz) do
      {_to: foo["_id"], type: "edge_from_foo_to_fizz", _from: fizz["_id"]}.insert.into :edges
    end

    let(:asdf) do
      {asdf: "ghjk"}.insert.into :nodes
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

    after(:each) do
      clean_out_db
    end

    it "grafts itself into the Hash class" do
      expect(Hash.ancestors).to include Graphiti
    end

    it "provides an edges method" do
      expect({foo: "bar"}.edges.results).to match_array [[edge_to_foo_from_baz, edge_to_foo_from_fizz]]
    end

    it "finds neighbors of neighbors" do
      # NB: the neighbor of foo's neighbor includes foo, our starting
      # point.
      expect({foo: "bar"}.neighbors.neighbors.results.first).to match_array [asdf, foo]
    end

    it "finds neighbors of the example hash" do
      expect({foo: "bar"}.neighbors.results.first).to match_array [baz, fizz]
    end

    it "finds neighbors using an options hash" do
      expect({foo: "bar"}.neighbors(maxDepth: 2).results.first).to match_array [asdf, fizz, baz]
    end

    it "finds matching vertices" do
      expect({foo: "bar"}.vertices.length).to be 1
    end

    it "inserts data and returns the entire hash" do
      expect(foo.keys).to match_array ["foo", "_id", "_rev", "_key"]
    end

    it "deletes data and returns the deleted hash" do
      Graphiti.truncate
      asdf = {asdf: 'ghjk'}.insert.into :nodes
      expect({asdf: 'ghjk'}.remove.from(:nodes)).to eq asdf
    end

    it "updates matching vertices in the specified collection" do
      pikachu = { name: 'Pikachu', species: 'pokémon', type: "yellow" }.insert.into :nodes
      pikachu["type"]= "electric"
      pikachu.update_in :nodes
      expect({name: 'Pikachu', species: 'pokémon'}.vertices.first["type"]).to eq "electric"
    end

    it "returns false when trying to update something that is not persisted" do
      expect({ abc: 123 }.update_in :nodes).to eq false
    end

    it "Finds its neighbors" do
      expect({foo: "bar"}.neighbors.results.first).to match_array [fizz, baz]
    end

    it "filters its neighbors" do
      expect({foo: "bar"}.neighbors.filter(fizz: "buzz").results).not_to include baz
    end

  end

end
