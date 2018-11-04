# README

Ruby version:
Ruby 2.5.3

System dependencies:
install phantomjs

Database creation:
'psql > create database test_db'

Database initialization:
'rake db:migration'

To start program, do 'rails s'. This will start a local server on :3000 that provide an admin panel to add product to the database.

Program uses postgres database to persist products data.
Database has records of events, unposted events and posters. Posters are websites that events will be posted to.
Program post new events to multiple websites using capybara and api(if available) at time intervals. This happens in the ./lib/syndicator.rb.
