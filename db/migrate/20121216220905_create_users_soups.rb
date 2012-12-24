class CreateUsersSoups < ActiveRecord::Migration
  def change
    create_table :users_soups, :id => false do |t|
      t.references :user
      t.references :soup
    end
  end
end
