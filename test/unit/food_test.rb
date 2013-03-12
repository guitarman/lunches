require 'test_helper'

class FoodTest < ActiveSupport::TestCase
  test "should create food" do
    food = Food.new
    food.name = "Bryndzove halusky"

    assert food.save!
  end

  test "should update food" do
    food = foods(:rezen)
    assert food.update_attributes!(:name => "Vyprazany rezen so salatom")
  end

  test "should add food and soup to restaurant" do
    restaurant = restaurants(:restauracia1)
    food = foods(:rezen)
    soup = soups(:rajcinova)
    day_menu_food = DayMenu.create(:for_day => Time.now)
    day_menu_soup = DayMenu.create(:for_day => Time.now)

    food.day_menus << day_menu_food
    restaurant.day_menus << day_menu_food

    soup.day_menus << day_menu_soup
    restaurant.day_menus << day_menu_soup

    sleep(1)
    assert_equal(restaurant.today_foods[0], food)
    assert_equal(restaurant.today_soups[0], soup)
  end
end