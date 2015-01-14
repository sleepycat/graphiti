require 'pry'
require 'spec_helper'
require 'graphiti'

module Graphiti

  RSpec.describe Query do

    let(:db){ {}.send(:db) }

    it "creates a valid AQL query" do
      results = db.query.valid? Query.new(List.new(foo: "bar")).aql
      expect(results).to eq true
    end

  end

end
