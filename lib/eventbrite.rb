
require './product.rb'
require 'net/http'
require 'json'
require 'time'

class Eventbrite
  
  def initialize(config)
    @eventbrite_oauth_token = config["token"]
  end
  
  def login(email, password)
  	visit "https://www.eventbrite.com/signin/"

  	fill_in :email, with: email
    click_on "Get Started"
  	fill_in :password, with: password
  	click_on "Log In"
  end

  def post_event(org_id, prod)
    event = 
    { 
      "event":
      {
        "name": {
          "html": prod.pname
        },
        "description": {
          "html": prod.description
        },
        "start": {
          "timezone": "America/New_York",
          "utc": prod.start_time.getutc.strftime("%Y-%m-%dT%TZ")
        },
        "end": {
          "timezone": "America/New_York",
          "utc": prod.end_time.getutc.strftime("%Y-%m-%dT%TZ")
        },
        "currency": "USD"
      }
    }
    uri = URI.parse("https://www.eventbriteapi.com/v3/organizations/#{org_id}/events/?token=#{@eventbrite_oauth_token}")
    req = Net::HTTP::Post.new(uri, 'Content-Type' => "application/json")
    req.body = event.to_json

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    resp = http.request(req)
    if resp.kind_of? Net::HTTPSuccess
      return JSON.parse(resp.body)["id"]
    end
    return nil
  end

  def post_ticket(event_id, prod)
    ticket =
    {
      "ticket_class":
      {
        "name": "General",
        "quantity_total": 1000,
        "cost": "USD," + (prod.price * 100).to_i.to_s,
        "free": false
      }
    }
    uri = URI.parse("https://www.eventbriteapi.com/v3/events/#{event_id}/ticket_classes/?token=#{@eventbrite_oauth_token}")
    req = Net::HTTP::Post.new(uri, 'Content-Type' => "application/json")
    req.body = ticket.to_json

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    resp = http.request(req)
    if resp.kind_of? Net::HTTPSuccess
      return true
    end
    return false
  end

  def publish_event(event_id)
    uri = URI.parse("https://www.eventbriteapi.com/v3/events/#{event_id}/publish/?token=#{@eventbrite_oauth_token}")
    req = Net::HTTP::Post.new(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    resp = http.request(req)
    if resp.kind_of? Net::HTTPSuccess
      return true
    end
    return false
  end

  def get_date_and_time(time)
    date = time.strftime "%m/%d/%Y"
    hour = time.strftime("%I")
    am_pm = time.strftime "%P"
    min_i = time.strftime("%M").to_i
    min = "00"
    if min_i > 30
      min = "30"
    end
    t = hour + ":" + min + am_pm
    return date, t
  end
  
  def create_event(prod)
    posted = true
    begin
      # get org id
      uri = URI.parse("https://www.eventbriteapi.com/v3/users/me/organizations/?token=#{@eventbrite_oauth_token}")
      req = Net::HTTP::Get.new(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      resp = http.request req
      if !resp.kind_of? Net::HTTPSuccess
        return false
      end
      org_id = JSON.parse(resp.body)["organizations"][0]["id"]
      if org_id == nil
        return false
      end
      
      # post event
      event_id = post_event(org_id, prod)
      if event_id == nil
        return false
      end

      # post ticket
      if !post_ticket(event_id, prod)
        return false
      end

      # publish event and
      return publish_event(event_id)
    rescue => e
      puts e.message
      posted = false
    end
    return posted
  end
end
