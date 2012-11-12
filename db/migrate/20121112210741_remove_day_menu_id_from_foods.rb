class RemoveDayMenuIdFromFoods < ActiveRecord::Migration
  def change
    remove_column :foods, :day_menu_id
  end
end
