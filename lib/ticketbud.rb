require 'capybara'
require 'capybara/dsl'
require './product.rb'

class Ticketbud
  include Capybara::DSL
  
  def initialize(config)
    Capybara.default_driver = :selenium
    @email = config["username"]
    @password = config["password"]
  end

  def login
  	visit "https://ticketbud.com/users/sign_in"
  	fill_in :user_email, with: @email
  	fill_in :user_password, with: @password
  	click_on "Log in"
  end

  def fill(prod)
    visit "https://ticketbud.com/start/"
    sleep 1
  	#fill in event name
  	fill_in "event-title", with: prod.pname
    #add ticket
    click_on "Add ticket"
    sleep 1
    fill_in "General Admission", with: "general"
    fill_in "100", with: "10000"
    fill_in "25.00", with: 55.9
  	#fill in start time and end time
  	start_date, start_time = get_date_and_time(prod.start_time)
  	end_date, end_time = get_date_and_time(prod.end_time)
  	fill_in "event-start", with: start_date
    fill_in "event-end", with: end_date
    execute_script("$('event-start-time').val('#{start_time}')")
    execute_script("$('event-end-time').val('#{end_time}')")
    sleep 1
  	#post event
  	click_on "Continue"
    sleep 1 
    return has_content("created")
  end

  def get_date_and_time(time)
  	date = time.strftime "%m/%d/%Y"
  	hour = time.strftime("%l").strip
  	am_pm = time.strftime "%p"
  	min_i = time.strftime("%M").to_i
    min = "00"
    if min_i < 15
      min = "00"
  	elsif min_i < 30
  		min = "15"
    elsif min_i < 45
      min = "30"
    else 
      min = "45"  
  	end
  	t = hour + ":" + min + " " + am_pm
  	return date, t
  end

  def create_event(prod)
    posted = true
    begin
    	login
    	sleep 4
    	fill prod
    rescue => e
      posted = false
      puts e.message
    end
    return posted
  end
end