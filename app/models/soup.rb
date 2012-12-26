class Soup < ActiveRecord::Base
  attr_accessible :name

  has_many :day_menus
  has_many :restaurants, :through => :day_menus

  has_and_belongs_to_many :users, :join_table => "users_soups", :uniq => true

  def to_param
    name.parameterize
  end
end
