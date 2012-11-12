class Restaurant < ActiveRecord::Base
  has_many :day_menus
  has_many :foods, :through => :day_menus
  has_many :soups, :through => :day_menus
end
