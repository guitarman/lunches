class DayMenu < ActiveRecord::Base
  #attr_accessible :for_day
  belongs_to :restaurant
  has_many :foods
end
