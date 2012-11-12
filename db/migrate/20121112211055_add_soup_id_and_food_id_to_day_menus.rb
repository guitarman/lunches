class AddSoupIdAndFoodIdToDayMenus < ActiveRecord::Migration
  def change
    add_column :day_menus, :food_id,  :integer
    add_column :day_menus, :soup_id, :integer
  end
end
