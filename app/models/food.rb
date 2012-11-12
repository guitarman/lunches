class Food < ActiveRecord::Base
  attr_accessible :name
  belongs_to :day_menu
end
