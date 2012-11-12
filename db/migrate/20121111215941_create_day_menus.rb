class CreateDayMenus < ActiveRecord::Migration
  def change
    create_table :day_menus do |t|
      t.integer :restaurant_id
      t.datetime :for_day
    end
  end
end
