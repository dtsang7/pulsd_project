class Product
	attr_reader :pname
	attr_reader :description
	attr_reader :start_time
	attr_reader :end_time
	attr_reader :price

	def initialize(pname, desc, start_time, end_time, price)
		@pname = pname
		@description = desc
		@start_time = start_time
		@end_time = end_time
		@price = price
	end
end
