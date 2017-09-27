require 'mongo'

include Mongo

client_host = ['mongodb:27017']
client_options = {
  database: 'test'
}

client = Mongo::Client.new(client_host, client_options)

loop do
        IO.binwrite("/dev/null", ">:t:aggregate::")

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

        IO.binwrite("/dev/null", "<:t:aggregate::")
end
