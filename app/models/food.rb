class Food < ActiveRecord::Base
  attr_accessible :name

  has_many :day_menus
  has_many :restaurants, :through => :day_menus

  has_and_belongs_to_many :users
end
