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

  describe '.truncate' do

    it 'deletes the current database by truncation' do
      {foo: "bar"}.insert.into :vertices
      Graphiti.truncate
      expect({foo: "bar"}.vertices.length).to eq 0
    end

  end

  describe ".config" do

    it "returns a configuration object" do
      expect(Graphiti.config).to be_a Configuration
    end

  end

  describe ".database" do

    it "returns the underlying database object" do
      expect(Graphiti.database).to be_a Ashikawa::Core::Database
    end

  end

  before(:each) do
    {_to: foo["_id"], _from: fizz["_id"]}.insert.into :edges
    {_to: foo["_id"], _from: baz["_id"]}.insert.into :edges
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

  after(:each) do
    Graphiti.truncate
  end



  let(:db){ Graphiti.database }

  it "grafts itself into the Hash class" do
    expect(Hash.ancestors).to include Graphiti
  end

  it "provides an edges method" do
    expect({foo: "bar"}.edges.results.length).to be 2
  end

  it "finds neighbors of the example hash" do
    expect({foo: "bar"}.neighbors.length).to be 1
  end

  it "finds neighbors using an options hash" do
    expect({foo: "bar"}.neighbors(maxDepth: 2).results.length).to be 2
  end

  it "finds matching vertices" do
    expect({foo: "bar"}.vertices.length).to be 1
  end

  it "inserts data and returns the hash" do
    expect({name: "foo", type:"foo"}.insert.into(:vertices).keys).to match_array ["name", "type"]

  end

  it "deletes data" do
    expect({name: "foo", type:"foo"}.remove.from(:vertices)).to eq []
  end

  it "Finds its neighbors" do
    expect({foo: "bar"}.neighbors.results).to  eq [fizz, baz]
  end

  it "filters its neighbors" do
    expect({foo: "bar"}.neighbors.filter(fizz: "buzz").results).not_to include baz
  end

end
