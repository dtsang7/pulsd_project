require 'capybara'
require 'capybara/dsl'
require './product.rb'

class Eventsorg
  include Capybara::DSL
  
  def initialize(config)
    Capybara.default_driver = :selenium
    @email = config["username"]
    @password = config["password"]
  end

  def fill(prod)
    visit "https://events.org/manage/event/quickcreate"
  	#fill in event name
  	fill_in :Name, with: prod.pname
    #fill in start time and end time
    choose("multiday", visible: false)
  	start_date, start_time = get_date_and_time(prod.start_time)
  	end_date, end_time = get_date_and_time(prod.end_time)
  	
    fill_in :StartDate, with: start_date
    fill_in :EndDate, with: ''
  	fill_in :EndDate, with: end_date
  	#fill in email and password
  	fill_in :AccountEmail, with: @email
    fill_in :AccountPassword, with: @password
    #fill in location
    fill_in :location, with: "New York, NY, USA"
  	#post event
  	click_on "Create"
    execute_script("$('#hdnLongitude').val('-74.0059728')")
    execute_script("$('#hdnLatitude').val('40.7127753')")
    sleep 1
    click_on "Create"
    return has_content?("Event Created!")
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
    	fill prod
    rescue => e
      posted = false
      puts e.message
    end
    return posted
  end
end
