require 'pry'
require 'spec_helper'
require 'graphiti'

RSpec.describe Graphiti do

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

  before(:each) do
    {foo: "bar"}.insert.into :vertices
    foo = {foo: "bar"}.vertices.first
    {fizz: "buzz"}.insert.into :vertices
    fizz = {fizz: "buzz"}.vertices.first
    {_to: foo["_id"], _from: fizz["_id"]}.insert.into :edges
  end

  after(:each) do
    db.truncate
  end

  let(:options) do
    {
      url: "http://127.0.0.1:8529",
      database_name: "test",
      username: "",
      password: "",
      graph: "test"
    }
  end

  let(:db){ {}.send(:db) }

  it "grafts itself into the Hash class" do
    expect(Hash.ancestors).to include Graphiti
  end

  it "accepts configuration" do
    expect(Graphiti.configure(options)).to eq true
  end

  it "provides an edges method" do
    expect({foo: "bar"}.edges.length).to be 1
  end

  it "finds neighbors of the example hash" do
    expect({foo: "bar"}.neighbors.length).to be 1
  end

  it "finds neighbors using an options hash" do
    expect({foo: "bar"}.neighbors(maxDepth: 2).length).to be 1
  end

  it "finds matching vertices" do
    expect({foo: "bar"}.vertices.length).to be 1
  end

  it "inserts data" do
    expect({name: "foo", type:"foo"}.insert.into(:vertices)).to eq []
  end

  it "deletes data" do
    expect({name: "foo", type:"foo"}.remove.from(:vertices)).to eq []
  end

end
