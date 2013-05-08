class Restaurant < ActiveRecord::Base
  attr_accessible :name, :address, :url

  has_many :day_menus
  has_many :foods, :through => :day_menus
  has_many :soups, :through => :day_menus

  def today_foods(date)
    self.foods.where("for_day < ? and for_day > ?", date, date.midnight)
  end

  def today_soups(date)
    self.soups.where("for_day < ? and for_day > ?", date, date.midnight)
  end
end
