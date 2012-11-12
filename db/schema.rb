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

ActiveRecord::Schema.define(:version => 20121111220106) do

  create_table "day_menus", :force => true do |t|
    t.integer  "restaurant_id"
    t.datetime "for_day"
  end

  create_table "foods", :force => true do |t|
    t.string  "name"
    t.integer "day_menu_id"
  end

  create_table "restaurants", :force => true do |t|
    t.string "name"
    t.string "address"
    t.string "url"
  end

  create_table "soups", :force => true do |t|
    t.string "name"
  end

end
