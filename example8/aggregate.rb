require 'mongo'

include Mongo

$stdout.sync = true

client_host = ['mongodb:27017']
client_options = {
  database: 'test'
}

client = Mongo::Client.new(client_host, client_options)

loop do
	print ">:t:aggregate::\n" # Mark the beginning of the query

	results = client[:customers].aggregate( [
	                    { "$match" => {}},
	                    { "$group" => {
	                                  "_id" => "$country_code",
	                                  "value" => { "$sum" => "$orders_count" }
	                                }
	                   }
	           ])

        #results.each do |result|
        #    puts result
        #end


	print "<:t:aggregate::\n" # Mark the end of the query
end
