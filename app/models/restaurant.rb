class Restaurant < ActiveRecord::Base
  #attr_accessible :title, :body
  has_many :day_menus
  has_many :menus, :through => :day_menus, :source => :foods
end
