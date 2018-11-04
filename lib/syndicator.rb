require 'time'
require 'yaml'
require './db.rb'
require './eventbrite.rb'
require './eventsorg.rb'
require './yelp.rb'
require './ticketbud.rb'

class Syndicator
	def initialize
		@config = YAML.load(File.open('config.yml').read
		posters = Hash.new
		posters["eventbrite"] = Eventbrite.new(@config["eventbrite"])
		posters["eventsorg"] = Eventsorg.new(@config["eventsorg"])
		posters["yelp"] = Yelp.new(@config["yelp"])
		posters["ticketbud"] = Ticketbud.new(@config["ticketbud"]])
	end

	def repost_products
		db = DB.new(config["dbname"])
		repost_events, prod_map = db.retrieve_new_products
		repost_events.each do |event|
			posters[event["poster_name"].create_event(prod_map[event["product_id"]])
			db.remove(event["product_id"], event["poster_name"])
		end
	end
end
