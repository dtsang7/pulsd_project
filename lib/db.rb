require 'pg'
class DB
	@conn = nil
	def initialize(dbname)
		begin
			@conn = PG.connect :dbname => dbname
		rescue PG::Error => e
		    puts e.message 
		end
	end

	def retrieve_new_products
		repost_events = nil
		product_map = {}
		begin
			@conn.transaction do |conn|
				# retrieve list of reposting events
				repost_events = conn.exec "SELECT * FROM repost_queue;"
				products_res = conn.exec "SELECT * from products where id in (SELECT DISTINCT(product_id) FROM repost_queue);"
				products_res.each do |prod|
					product_map[prod["id"]] = Product.new prod["name"], prod["description"], Time.parse(prod["start_time"]), Time.parse(prod["end_time"]), prod["price"]
				end
			end
		rescue PG::Error => e
		    puts e.message 
		end
		return repost_events, product_map
	end

	def remove(product_id, poster_name)
		begin
			@conn.exec "DELETE FROM repost_queue WHERE product_id = #{product_id} AND poster_name = '#{poster_name}';"
		rescue PG::Error => e
		    puts e.message 
		end
	end
end