# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_11_04_180602) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "posters", primary_key: "name", id: :text, force: :cascade do |t|
  end

  create_table "products", force: :cascade do |t|
    t.text "pname"
    t.text "description"
    t.datetime "start_time"
    t.datetime "end_time"
    t.decimal "price"
  end

  create_table "repost_queues", force: :cascade do |t|
    t.integer "product_id"
    t.text "poster_name"
  end

end
