require 'rubygems'
require 'nokogiri'
require 'open-uri'

class LunchController < ApplicationController
  def index
    @restaurants = Restaurant.all

    respond_to do |format|
      format.html
      #format.xml { render:xml => @restaurants }
    end
  end

  def download_pages
    @restaurants = Restaurant.all

    @restaurants.each do |restaurant|
      page = Nokogiri::HTML(open(restaurant.url))
      #content = page.class
    end
  end
end
