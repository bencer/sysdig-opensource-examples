require 'mongo'

include Mongo

client_host = ['mongodb:27017']
client_options = {
  database: 'test'
}

client = Mongo::Client.new(client_host, client_options)

loop do
        IO.binwrite("/dev/null", ">:t:map-reduce::")

        mapreduced = client[:customers].find.map_reduce("function() { emit(this.country_code, this.orders_count) }",
                  "function(key,values) { return Array.sum(values) }", { :out => { :inline => true }, :raw => true})

        #mapreduced.each { |x| puts x }

        IO.binwrite("/dev/null", "<:t:map-reduce::")
end
