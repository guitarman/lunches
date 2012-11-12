class Food < ActiveRecord::Base
  attr_accessible :name

  has_many :day_menus
  has_many :restaurants, :through => :day_menus
end
