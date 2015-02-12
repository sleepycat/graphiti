require 'pry'
require 'graphiti'

RSpec.configure do |config|

  # As Lessig says: "embrace the irony"
  config.disable_monkey_patching!


  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before(:suite) do
    options = {
      url: "http://127.0.0.1:8529",
      database_name: "test",
      username: "",
      password: "",
      graph: "test"
    }
    Graphiti.configure options
    $conn = Faraday.new(:url => "http://127.0.0.1:8529") do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
  end

end

def clean_out_db
  # GET /_api/collection
  res = JSON.parse($conn.get("/_db/test/_api/collection", {excludeSystem: true}).body)
  collections = res["names"].keys
  collections.each do |collection|
    # PUT /_api/collection/{collection-name}/truncate
    $conn.put "/_db/test/_api/collection/#{collection}/truncate"
  end
end


def validate_aql aql
  res = $conn.post do |req|
    req.url "/_db/test/_api/query"
    req.headers['Content-Type'] = 'application/json'
    req.headers['Authorization'] = "Basic #{Base64.encode64("'':''")}"
    req.body = { query: aql }.to_json
  end

  result = JSON.parse(res.body)
  if result["error"]
    result['errorMessage']
  else
    true
  end
end

def execute_query aql, bindvars
  res = $conn.post do |req|
    req.url "/_db/test/_api/cursor"
    req.headers['Content-Type'] = 'application/json'
    req.headers['Authorization'] = "Basic #{Base64.encode64("'':''")}"
    req.body = { query: aql, bindVars: bindvars }.to_json
  end

  result = JSON.parse(res.body)
  result["result"]
end
