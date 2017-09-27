require 'faker'
require 'mongo'

include Mongo

client_host = ['mongodb:27017']
client_options = {
  database: 'test'
}

client = Mongo::Client.new(client_host, client_options)

90000.times do
	client[:customers].insert_one({
			:first_name => Faker::Name.first_name,
			:last_name => Faker::Name.last_name,
			:city => Faker::Address.city,
			:country_code => Faker::Address.country_code,
			:orders_count => Random.rand(10)+1
		})
end
