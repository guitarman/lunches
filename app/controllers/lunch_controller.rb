# encoding: UTF-8
require 'rubygems'
require 'open-uri'
require 'nokogiri'
require 'timeout'

class LunchController < ApplicationController
  before_filter :authenticate, :only => [:add_soup, :delete_soup, :add_food, :delete_food]

  def index
    @restaurants = Restaurant.all

    respond_to do |format|
      format.html #index.html.erb
      format.xml { render :xml => @restaurants }
    end
  end

  def download_pages
    @restaurants = Restaurant.all
    @messages = []

    @restaurants.each do |restaurant|
      begin
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
      rescue Error => e
        @messages << e.message
      end
    end

    if @messages.any?
      respond_to do |format|
        format.html #download_pages.html.erb
        format.xml { render :xml => @messages }
      end
    else
      redirect_to :action => 'index'
    end
  end

  def add_soup
    begin
      soup = Soup.find(params[:id])
      current_user.soups << soup

      redirect_to :back, :notice => "Polievka bola pridaná k obľúbeným jedlám"
    rescue
      redirect_to :back, :alert => "Nastala chyba pri pridávaní polievky k obľúbeným jedlám"
    end
  end

  def delete_soup
    begin
      soup = Soup.find(params[:id])
      current_user.soups.delete(soup)

      redirect_to :back, :notice => "Polievka bola odstránená z obľúbených jedál"
    rescue
      redirect_to :back, :alert => "Nastala chyba pri odstraňovaní polievky z obľúbených jedál"
    end
  end

  def add_food
    begin
      food = Food.find(params[:id])
      current_user.foods << food

      redirect_to :back, :notice => "Jedlo bolo pridané k obľúbeným jedlám"
    rescue
      redirect_to :back, :alert => "Nastala chyba pri pridávaní jedla k obľúbeným jedlám"
    end
  end

  def delete_food
    begin
      food = Food.find(params[:id])
      current_user.foods.delete(food)

      redirect_to :back, :notice => "Jedlo bola odstránené z obľúbených jedál"
    rescue
      redirect_to :back, :alert => "Nastala chyba pri odstraňovaní jedla z obľúbených jedál"
    end
  end

  private
  def open_page(url)
    resp = ""
    begin
    Timeout::timeout(60) {
      open(url) { |f|
        resp = f.read
      }
    }
    rescue Timeout::Error => e
      raise e
    end

    Nokogiri::HTML(resp)
  end

  def save_food(food_name, restaurant)
    unless food_name.empty?
      day_menu = DayMenu.create(:for_day => Time.now)
      food = Food.find_or_create_by_name(food_name)

      food.day_menus << day_menu
      restaurant.day_menus << day_menu
    end
  end

  def save_soup(soup_name, restaurant)
    unless soup_name.empty?
      day_menu = DayMenu.create(:for_day => Time.now)
      soup = Soup.find_or_create_by_name(soup_name)

      soup.day_menus << day_menu
      restaurant.day_menus << day_menu
    end
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
    if node.children().count >= 13
      #soup
      soup = node.children()[2].text
      save_soup(soup.to_s.gsub("Polievka:", "").strip, restaurant)

      node.children().each do |child|
          if child.text.include?("1)")
            food1 = child.text
            save_food(food1.to_s.gsub("1)","").strip, restaurant)
          elsif child.text.include?('2)')
            food2 = child.text
            save_food(food2.to_s.gsub("2)","").strip, restaurant)
          elsif child.text.include?('3)')
            food3 = child.text
            save_food(food3.to_s.gsub("3)","").strip, restaurant)
          elsif child.text.include?('4)')
            food4 = child.text
            save_food(food4.to_s.gsub("4)","").strip, restaurant)
          elsif child.text.include?('5)')
            food5 = child.text
            save_food(food5.to_s.gsub("5)","").strip, restaurant)
            break
          end
      end
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
