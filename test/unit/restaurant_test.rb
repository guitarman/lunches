require 'test_helper'

class RestaurantTest < ActiveSupport::TestCase
  test "should create restaurant" do
    restaurant = Restaurant.new
    restaurant.name = "Restauracia 2"
    restaurant.address = "Ulica c. 2"
    restaurant.url = "http://restauracia2.com"

    assert restaurant.save!
  end

  test "should update restaurant" do
    restaurant = restaurants(:restauracia1)
    assert restaurant.update_attributes!(:name => "Restauracia 11")
  end

  test "should find restaurant" do
    restaurant_id = restaurants(:restauracia1).id
    assert_nothing_raised { Restaurant.find(restaurant_id) }
  end

  test "should destroy restaurant" do
    restaurant = restaurants(:restauracia1)
    restaurant.destroy
    assert_raise(ActiveRecord::RecordNotFound) { Restaurant.find(restaurant.id) }
  end
end