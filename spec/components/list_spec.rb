require 'spec_helper'
require 'graphiti'

module Graphiti

  RSpec.describe List do

    it "creates a valid AQL query" do
      results = validate_aql "RETURN #{List.new(foo: "bar").aql}"
      expect(results).to eq true
    end

    it "can be nested" do
      results =  validate_aql "RETURN #{List.new(List.new(foo: "bar")).aql}"
      expect(results).to eq true
    end

  end

end
