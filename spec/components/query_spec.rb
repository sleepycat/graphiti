require 'pry'
require 'spec_helper'
require 'graphiti'

module Graphiti

  RSpec.describe Query do

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

    it "creates a valid AQL query" do
      results = db.query.valid? Query.new(List.new(foo: "bar")).aql
      expect(results).to eq true
    end

  end

end
