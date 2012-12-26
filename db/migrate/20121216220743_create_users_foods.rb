class CreateUsersFoods < ActiveRecord::Migration
  def change
    create_table :users_foods, :id => false do |t|
      t.references :user
      t.references :food
    end

    add_index :users_foods, [ :user_id, :food_id ], :unique => true, :name => 'by_user_and_food'
  end
end
