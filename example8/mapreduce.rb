require 'mongo'

include Mongo

$stdout.sync = true

client_host = ['mongodb:27017']
client_options = {
  database: 'test'
}

client = Mongo::Client.new(client_host, client_options)

loop do
        print ">:t:map-reduce::\n" # Mark the beginning of the query

        mapreduced = client[:customers].find.map_reduce("function() { emit(this.country_code, this.orders_count) }",
                  "function(key,values) { return Array.sum(values) }")

        #mapreduced.each { |x| puts x }

        print "<:t:map-reduce::\n" # Mark the end of the query
end
