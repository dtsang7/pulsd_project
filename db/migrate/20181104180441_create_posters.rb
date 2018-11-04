class AddPosters < ActiveRecord::Migration[5.2]
  def change
  	create_table :posters, {:id => false} do |t|
      t.text :name 
    end
    execute "ALTER TABLE posters ADD PRIMARY KEY (name);"
    execute  "INSERT INTO posters VALUES('eventbrite');"
	execute  "INSERT INTO posters VALUES('yelp');"
	execute  "INSERT INTO posters VALUES('eventsorg');"
	execute  "INSERT INTO posters VALUES('ticketleap');"
	execute  "INSERT INTO posters VALUES('twitter');"
  end
end
