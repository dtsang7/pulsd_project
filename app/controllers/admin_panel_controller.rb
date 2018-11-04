class AdminPanelController < ApplicationController

	def home
		@products = Product.all
	end

	def new
		@product = Product.new
	end

	def create
		@product = Product.new(product_params)
		if @product.save 
			@posters = Poster.all
			@posters.each do |poster|
				repost_event = RepostQueue.new
				repost_event.poster_name = poster.name
				repost_event.product_id = @product.id
				repost_event.save
			end
			redirect_to '/admin_panel'
		else
			render 'new'
		end
	end

    private
		def product_params
			premitted = params.require(:product).permit(:pname, :start_time, :end_time, :price, :description)
		end
end
