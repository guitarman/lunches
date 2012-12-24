class CreateUsersFoods < ActiveRecord::Migration
  def change
    create_table :users_foods, :id => false do |t|
      t.references :user
      t.references :food
    end
  end
end
