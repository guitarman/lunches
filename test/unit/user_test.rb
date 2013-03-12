require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should create user" do
    user = User.new
    user.email = "jano@jano.com"
    user.password = "pwd123"
    user.password_confirmation = "pwd123"

    assert user.save!
  end

  test "should update user" do
    user = users(:peto)
    assert user.update_attributes!(:email => "peto2@peto.com", :password => "pwd123")
  end

  test "should like food" do
    user = users(:peto)
    food = foods(:rezen)
    user.foods << food

    assert user.likes_food?(food)
  end

  test "should like soup" do
    user = users(:peto)
    soup = soups(:rajcinova)
    user.soups << soup

    assert user.likes_soup?(soup)
  end

  test "should not like food" do
    user = users(:peto)
    food = foods(:rezen)
    user.soups = []

    assert !user.likes_food?(food)
  end

  test "should not like soup" do
    user = users(:peto)
    soup = soups(:rajcinova)
    user.soups = []

    assert !user.likes_soup?(soup)
  end

  test "should not create user with short password" do
    user = User.new
    user.email = "jano@jano.com"
    user.password = "p"
    user.password_confirmation = "p"

    assert !user.valid?
    assert user.errors[:password].any?
    assert_equal ["is too short (minimum is 4 characters)"], user.errors[:password]
    assert !user.save
  end

  test "should not create user with long password" do
    user = User.new
    user.email = "jano@jano.com"
    user.password = "123456789012345678901"
    user.password_confirmation = "123456789012345678901"

    assert !user.valid?
    assert user.errors[:password].any?
    assert_equal ["is too long (maximum is 20 characters)"], user.errors[:password]
    assert !user.save
  end

  test "should not create user with wrong email format" do
    user = User.new
    user.email = "jano.com"
    user.password = "pwd123"
    user.password_confirmation = "pwd123"

    assert !user.valid?
    assert user.errors[:email].any?
    assert_equal ["is invalid"], user.errors[:email]
    assert !user.save
  end

  test "should not create user with invalid password confirmation" do
    user = User.new
    user.email = "jano@jano.com"
    user.password = "pwd123"
    user.password_confirmation = "pwd321"

    assert !user.valid?
    assert user.errors[:password].any?
    assert_equal ["doesn't match confirmation"], user.errors[:password]
    assert !user.save
  end
end