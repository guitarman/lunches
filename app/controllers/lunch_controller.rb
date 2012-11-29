require 'rubygems'
require 'open-uri'
require 'nokogiri'
require 'timeout'

class LunchController < ApplicationController
  def index
    @restaurants = Restaurant.all

    respond_to do |format|
      format.html
      format.xml { render :xml => @restaurants }
    end
  end

  def download_pages
    @restaurants = Restaurant.all

    @restaurants.each do |restaurant|
      if restaurant.name.include?("Ekon")
        get_ekonom(restaurant)
      end
      if restaurant.name.include?("U Lod")
        get_lodnik(restaurant)
      end
      if restaurant.name.include?("Mlyn")
        get_mlyn(restaurant)
      end
      if restaurant.name.include?("Sit")
        get_siteat(restaurant)
      end
      if restaurant.name.include?("Presto")
        get_presto(restaurant)
      end
    end

    @message = 'done'

    respond_to do |format|
      format.html
      format.xml { render :xml => @message }
    end
  end

  private
  def open_page(url)
    resp = ""
    begin
    status = Timeout::timeout(60) {
      open(url) { |f|
        resp = f.read
      }
    }
    rescue Timeout::Error => e
      #logger.debug
    end

    if resp.empty?
      puts "got nothing from url"
    end

    Nokogiri::HTML(resp)
  end

  def save_food(food_name, restaurant)
    day_menu = DayMenu.create(:for_day => Time.now)
    food = Food.create(:name => food_name)

    food.day_menus << day_menu
    restaurant.day_menus << day_menu
  end

  def save_soup(soup_name, restaurant)
    day_menu = DayMenu.create(:for_day => Time.now)
    soup = Soup.create(:name => soup_name)

    soup.day_menus << day_menu
    restaurant.day_menus << day_menu
  end

  def get_ekonom(restaurant)
    page = open_page(restaurant.url)
    evens = page.xpath('//tr[@class = "even"]')
    odds = page.xpath('//tr[@class = "odd"]')
    if evens.count == 3 && odds.count == 2
      save_soup(evens[0].text.strip, restaurant)

      save_food(odds[0].text.strip, restaurant)
      save_food(evens[1].text.strip, restaurant)
      save_food(odds[1].text.strip, restaurant)
      save_food(evens[2].text.strip, restaurant)
    end
  end

  def get_lodnik(restaurant)
    page = open_page(restaurant.url)
    node = page.xpath('//div[(@class="texthelpods") and (contains(., "Polievka:"))]').first
    if node.children().count >= 30
      #soup
      soup = node.children()[2].text
      #foods
      food1 = node.children()[5].text
      food2 = node.children()[7].text
      food3 = node.children()[9].text
      food4 = node.children()[11].text
      food5 = node.children()[13].text

      save_soup(soup.to_s.gsub("Polievka:", "").strip, restaurant)

      save_food(food1.to_s.gsub("1)","").strip, restaurant)
      save_food(food2.to_s.gsub("2)","").strip, restaurant)
      save_food(food3.to_s.gsub("3)","").strip, restaurant)
      save_food(food4.to_s.gsub("4)","").strip, restaurant)
      save_food(food5.to_s.gsub("5)","").strip, restaurant)
    end
  end

  def get_mlyn(restaurant)
    days = %w(Pondelok Utorok Streda tvrtok Piatok)
    day_num = Time.now.wday - 1
    if day_num >= 0 && day_num <= 4
      page = open_page(restaurant.url)
      nodes = page.xpath('//span[contains(.,"' + days[day_num] + '")]/following-sibling::*')
      if nodes.length > 3
        soup = nodes[1].text
        save_soup(soup[soup.index(":")+1..-1].strip, restaurant)

        food = nodes[3].text
        foods = food.split('2.')
        save_food(foods[0][foods[0].index(":")+2..-1].strip, restaurant)
        if foods.count == 2
          save_food(foods[1], restaurant)
        end
      end
    end
  end

  def get_presto(restaurant)
    day_num = Time.now.wday - 1
    if day_num >= 0 && day_num <= 4
      page = open_page(restaurant.url)
      nodes = page.xpath('//td[@class = "cell-description"]')
      offset = day_num*8

      if nodes.count > (offset + 5)
        save_soup(nodes[offset + 0].text.strip, restaurant)
        save_soup(soup2 = nodes[offset + 1].text.strip, restaurant)

        save_food(nodes[offset + 2].text.strip, restaurant)
        save_food(nodes[offset + 3].text.strip, restaurant)
        save_food(nodes[offset + 4].text.strip, restaurant)
        save_food(nodes[offset + 5].text.strip, restaurant)
        save_food(nodes[offset + 6].text.strip, restaurant)
      end
    end
  end

  def get_siteat(restaurant)
    day_num = Time.now.wday - 1
    if day_num >= 0 && day_num <= 4
      page = open_page(restaurant.url)
      nodes = page.xpath('//td[@class = "cell-description"]')
      offset = day_num*8

      if nodes.count > (offset + 5)
          save_soup(nodes[offset + 0].text.strip, restaurant)
          save_soup(nodes[offset + 1].text.strip, restaurant)

          save_food(nodes[offset + 2].text.strip, restaurant)
          save_food(nodes[offset + 3].text.strip, restaurant)
          save_food(nodes[offset + 4].text.strip, restaurant)
          save_food(nodes[offset + 5].text.strip, restaurant)
      end
    end
  end
end
