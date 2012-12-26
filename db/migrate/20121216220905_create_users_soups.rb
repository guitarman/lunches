class CreateUsersSoups < ActiveRecord::Migration
  def change
    create_table :users_soups, :id => false do |t|
      t.references :user
      t.references :soup
    end

    add_index :users_soups, [ :user_id, :soup_id ], :unique => true, :name => 'by_user_and_soup'
  end
end
