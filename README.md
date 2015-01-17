# Graphiti

This library "vandalizes" your hash class to allow hash instances to talk
to the [ArangoDB](https://www.arangodb.com/) graph/document database.

This is a little experiment to see if some ~~monkey-patching~~
[freedom patching](http://vimeo.com/17420638#t=34m52s) and a little
hackery leads to something that feels natural with graphs.

## Trying it out:
```ruby
    options = {
      url: "http://127.0.0.1:8529",
      database_name: "test",
      username: "",
      password: "",
      graph: "test"
    }
    Graphiti.configure options
    Hash.include Graphiti

    # Insert into existing document collection
    foo = {foo: "bar"}.insert.into(:vertices).first

    # same same
    fizz = {fizz: "buzz"}.insert.into(:vertices).first

    # Inserting into an existing edge collection
    {_to: foo["_id"], _from: fizz["_id"]}.insert.into :edges

   {foo: "bar"}.neighbors(neighbourExamples: [{fizz:"buzz"}]).results
   => [{"vertex"=>{"_id"=>"vertices/651493941982", ..., "fizz"=>"buzz"}...
```

## Trying it with Rails

Using Graphiti with Rails currently looks like this:

```bash
mike@longshot:~/projects/my_rails_app☺  cat config/graphiti.yml
development:
  url: "http://127.0.0.1:8529"
  database_name: "my_rails_app_development"
  username: ""
  password: ""
  graph: "my_graph"
test:
  url: "http://127.0.0.1:8529"
  database_name: "my_rails_app_test"
  username: ""
  password: ""
  graph: "test"
production:
  url: "http://127.0.0.1:8529"
  database_name: "my_rails_app_production"
  username: "l337haxor"
  password: "password123"
  graph: "my_graph"


mike@longshot:~/projects/my_rails_app☺  cat config/initializers/graphiti.rb
options = YAML.load(File.read("#{Rails.root}/config/graphiti.yml"))[Rails.env]
Graphiti.configure options
# Now that Graphiti is configured we include it in the Hash class:
Hash.include Graphiti
```
From there you can start your Rails console and play. Don't forget that the
database and the graph/collections and whatnot need to exist beforehand.

```ruby
mike@longshot:~/projects/my_rails_app☺  rails c
Loading development environment (Rails 4.2.0)

 pry(main)> {name: "Loggerhead Shrike"}.neighbors.results
=> [{"_id"=>"nodes/151004795132", "_rev"=>"151004795132", "_key"=>"151004795132", "name"=>"Eastern subspecies", "type"=>"subspecies"},
 {"_id"=>"nodes/130377535740", "_rev"=>"130377535740", "_key"=>"130377535740", "name"=>"Birds", "type"=>"taxonomy_group"},
 {"_id"=>"nodes/150977073404", "_rev"=>"150989000956", "_key"=>"150977073404", "name"=>"migrans subspecies", "type"=>"subspecies", "scientific_name"=>"Lanius ludovicianus migrans"},
 {"_id"=>"nodes/151016198396", "_rev"=>"396053883277", "_key"=>"151016198396", "name"=>"Prairie subspecies", "type"=>"subspecies", "scientific_name"=>"Lanius ludovicianus excubitorides"}]

 pry(main)> {name: "Loggerhead Shrike"}.neighbors.filter(type: 'subspecies').results
=> [{"_id"=>"nodes/151004795132", "_rev"=>"151004795132", "_key"=>"151004795132", "name"=>"Eastern subspecies", "type"=>"subspecies"},
 {"_id"=>"nodes/150977073404", "_rev"=>"150989000956", "_key"=>"150977073404", "name"=>"migrans subspecies", "type"=>"subspecies", "scientific_name"=>"Lanius ludovicianus migrans"},
 {"_id"=>"nodes/151016198396", "_rev"=>"396053883277", "_key"=>"151016198396", "name"=>"Prairie subspecies", "type"=>"subspecies", "scientific_name"=>"Lanius ludovicianus excubitorides"}]
 pry(main)> {name: "Loggerhead Shrike"}.neighbors.filter(type: 'subspecies', name: 'migrans subspecies').results
=> [{"_id"=>"nodes/150977073404", "_rev"=>"150989000956", "_key"=>"150977073404", "name"=>"migrans subspecies", "type"=>"subspecies", "scientific_name"=>"Lanius ludovicianus migrans"}]
[12] pry(main)> {name: "Loggerhead Shrike"}.neighbors.filter(type: 'subspecies', name: 'migrans subspecies').neighbors.results
=> [{"_id"=>"nodes/329888561720", "_rev"=>"329892035128", "_key"=>"329888561720"...
```

## What its doing

At the moment any combination of
{}.neighbors(options).edges(options).filter(required_attributes) should
retrieve roughly what you might expect.

Behind the scenes Graphiti is assembling an AQL query and then the call to
results ({name: "Loggerhead Shrike"}.neighbors.results) at the end executes
the query.

For the moment the best/only documentation is the code and the specs.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'graphiti', github: 'sleepycat/graphiti'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install graphiti


## Contributing

1. Fork it ( https://github.com/sleepycat/graphiti/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request


## TODO

* Add sort method
* If a hash has a key with type: "foo" maybe it makes sense to save it to the "foo" collection.
* Explore Hashie's [method access](https://github.com/intridea/hashie/blob/master/lib/hashie/extensions/method_access.rb).
* Maybe it would be better to have all the graphiti methods on some itermediary object to avoid name clashes.
* Clean up the code
* Documentation
