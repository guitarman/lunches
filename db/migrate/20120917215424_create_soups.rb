class CreateSoups < ActiveRecord::Migration
  def change
    create_table :soups do |t|
      t.string :name
    end
  end
end
