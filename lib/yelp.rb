require 'capybara'
require 'capybara/dsl'
require './product.rb'

class Yelp
  include Capybara::DSL
  
  def initialize(config)
    Capybara.default_driver = :selenium
    @email = config["username"]
    @password = config["password"]
  end

  def login
  	visit "https://www.yelp.com/login"
  	fill_in :email, with: @email
  	fill_in :password, with: @password
  	click_on "Log In"
  end

  def fill(prod)
    visit "https://www.yelp.com/events/create"
    sleep 1
  	#fill in event name
  	fill_in :event_title, with: prod.pname
  	#fill in start time and end time
  	start_date, start_time = get_date_and_time(prod.start_time)
  	end_date, end_time = get_date_and_time(prod.end_time)
  	fill_in :starts_month_day_year, with: start_date
    select start_time, from: "starts_time"
  	click_on "Add end time"
  	fill_in :ends_month_day_year, with: end_date
    select end_time, from: "ends_time"
  	#fill in address
  	choose "Private Address"
  	fill_in :venue_name, with: "an venue"
  	fill_in :venue_street, with: "an address"
  	fill_in :venue_city_state_zip, with: "10011"
  	#fill in description
  	fill_in :description, with: prod.description
  	#fill in price
  	fill_in :cost, with: prod.price
  	fill_in :cost_max, with: prod.price
  	#select category
    select "Other", from: "category"
  	#post event
  	click_on "Create Event"
    sleep 1
    return has_content("created")
  end

  def get_date_and_time(time)
  	date = time.strftime "%m/%d/%Y"
  	hour = time.strftime("%l").strip
  	am_pm = time.strftime "%P"
  	min_i = time.strftime("%M").to_i
    min = "00"
  	if min_i > 30
  		min = "30"
  	end
  	t = hour + ":" + min + " " + am_pm
  	return date, t
  end

  def create_event(prod)
    posted = true
    begin
    	login
    	sleep 2
    	fill prod
    rescue => e
      posted = false
      puts e.message
    end
    return posted
  end
end