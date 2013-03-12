require 'test_helper'

class SoupTest < ActiveSupport::TestCase
  test "should create soup" do
    soup = Soup.new
    soup.name = "Hrachova polievka"

    assert soup.save!
  end

  test "should update soup" do
    soup = soups(:rajcinova)
    assert soup.update_attributes!(:name => "Rajcinova polievka")
  end
end