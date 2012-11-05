class LunchController < ApplicationController
  def index
    @restaurants = Restaurant.all

    respond_to do |format|
      format.html
      #format.xml { render:xml => @restaurants }
    end
  end
end
