class DayMenu < ActiveRecord::Base
  attr_accessible :for_day

  belongs_to :restaurant
  belongs_to :food
  belongs_to :soup
end
