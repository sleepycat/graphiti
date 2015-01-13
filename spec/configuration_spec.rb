require 'pry'
require 'spec_helper'
require 'graphiti'

module Graphiti
  RSpec.describe Configuration do

    let(:options) do
      {
        url: "http://127.0.0.1:8529",
        database_name: "test",
        username: "foo",
        password: "bar",
        graph: "test"
      }
    end


    it "sets the #url to return the value from the options" do
      expect(Configuration.new(options).url).to eq options[:url]
    end

    it "sets the #database_name to return the value from the options" do
      expect(Configuration.new(options).database_name).to eq options[:database_name]
    end

    it "sets the #username to return the value from the options" do
      expect(Configuration.new(options).username).to eq options[:username]
    end

    it "sets the #password to return the value from the options" do
      expect(Configuration.new(options).password).to eq options[:password]
    end

    it "sets the #graph to return the value from the options" do
      expect(Configuration.new(options).graph).to eq options[:graph]
    end

  end
end
