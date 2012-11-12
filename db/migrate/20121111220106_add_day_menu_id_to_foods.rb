class AddDayMenuIdToFoods < ActiveRecord::Migration
  def change
    add_column :foods, :day_menu_id, :integer
  end
end
