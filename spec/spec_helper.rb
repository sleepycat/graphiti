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
  end

end
