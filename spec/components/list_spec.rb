require 'spec_helper'
require 'graphiti'

module Graphiti

  RSpec.describe List do

    let(:db){ Graphiti.database }

    it "creates a valid AQL query" do
      results = db.query.valid? "RETURN #{List.new(foo: "bar").aql}"
      expect(results).to eq true
    end

    it "can be nested" do
      results =  db.query.valid? "RETURN #{List.new(List.new(foo: "bar")).aql}"
      expect(results).to eq true
    end

  end

end
