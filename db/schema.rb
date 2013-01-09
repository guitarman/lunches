# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121229124341) do

  create_table "day_menus", :force => true do |t|
    t.integer  "restaurant_id"
    t.datetime "for_day"
    t.integer  "food_id"
    t.integer  "soup_id"
  end

  create_table "foods", :force => true do |t|
    t.string "name"
  end

  create_table "restaurants", :force => true do |t|
    t.string "name"
    t.string "address"
    t.string "url"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "soups", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.boolean  "email_notification", :default => true
  end

  create_table "users_foods", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "food_id"
  end

  add_index "users_foods", ["user_id", "food_id"], :name => "by_user_and_food", :unique => true

  create_table "users_soups", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "soup_id"
  end

  add_index "users_soups", ["user_id", "soup_id"], :name => "by_user_and_soup", :unique => true

end
