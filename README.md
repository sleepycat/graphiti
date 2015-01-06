# Graphiti

This library vandalizes your hash class to allow hash instances to talk
to the ArangoDB graph/document database.

Creating classes/collection classes for each "type" of hash stored in a
graph starts to feel heavy after a while and so this library is a little
experiment to see what it feels like to work with hashes that are
connected to an Arango graph.

## Playing around:
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
    {foo: "bar"}.insert.into :vertices
    # Retrieve the vertex and store it in foo
    foo = {foo: "bar"}.vertices.first

    # same same
    {fizz: "buzz"}.insert.into :vertices
    fizz = {fizz: "buzz"}.vertices.first

    # Inserting into an existing edge collection
    {_to: foo["_id"], _from: fizz["_id"]}.insert.into :edges

   {foo: "bar"}.neighbors(neighbourExamples: [{fizz:"buzz"}])
   => [{"vertex"=>{"_id"=>"vertices/651493941982", ..., "fizz"=>"buzz"}...
```

This is a little experiment to see if some vicious monkey-patching and a little
hackery leads to something that feels natural with graphs. We'll see...


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

* Inserting hashes into the db should return the whole document. I'm assuming that [will be possible](http://stackoverflow.com/questions/27788089/insert-and-return-document-in-a-single-aql-query) with Arango 2.4.1.
* If a hash has a key with type: "foo" maybe it makes sense to save it to the "foo" collection.
* build up AQL queries Arel style so some complex queries can be done rather than the goofy hardcoding that is going on now.
* Explore Hashie's [method access](https://github.com/intridea/hashie/blob/master/lib/hashie/extensions/method_access.rb).
* Maybe it would be better to have all the graphiti methods on some itermediary object to avoid name clashes.
