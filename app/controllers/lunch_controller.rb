require 'rubygems'
require 'open-uri'
require 'nokogiri'

class LunchController < ApplicationController
  def index
    @restaurants = Restaurant.all

    respond_to do |format|
      format.html
      format.xml { render :xml => @restaurants }
    end
  end

  private
  def open_page(url)
    resp = ""
    open(url) { |f|
      resp = f.read
    }

    Nokogiri::HTML(resp)
  end

  def get_ekonom(url)
    @day_flag = false
    @ekonom_flag = false
    page = open_page(url)

    #Jedalny listok
    nodes = page.xpath('//html/body/form/table/tbody/tr/td/table/tbody/tr/td/table/tr/td/table/tr')

    nodes.length.times do |i|
      if @day_flag
        if nodes[i].text.include?('zajtra')
          break
        else
          if nodes[i].text.include?('Obed E')
            @ekonom_flag = true
            soup_food = nodes[i].inner_html.to_s

            soup = soup_food[soup_food.index('Polievka')..soup_food.index('</i>')-1]

            food1 = soup_food[soup_food.index('</i><br>')+8..-1]
            food2 = nodes[i+1].text
            food3 = nodes[i+2].text
            food4 = nodes[i+3].text

            food1 = food1[0..food1.index(' E')-1]
            food2 = food2[food2.index('&nbsp')+5..food2.index(' E')-1]
            food3 = food3[food3.index('&nbsp')+5..food3.index(' E')-1]
            food4 = food4[food4.index('&nbsp')+5..food4.index(' E')-1]
            break
          end
        end
        if nodes[i].text.include?('Obed HP') || nodes[i].text.include?('Minut')
          break
        else
          if @ekonom_flag
            obed = nodes[i].text
          end
        end
      else
        if nodes[i].text.include?('Dnes')
          @day_flag = true
        end
      end
    end
  end

  def get_lodnik(url)
    page = open_page(url)
    node = page.xpath('//div[(@class="texthelpods") and (contains(., "Polievka:"))]').first
    if node.children().count >= 50
      #soup
      soup = node.children()[2].text
      #foods
      food1 = node.children()[5].text
      food2 = node.children()[7].text
      food3 = node.children()[9].text
      food4 = node.children()[11].text
      food5 = node.children()[13].text

      soup = soup.to_s.gsub("Polievka:", "").strip

      food1 = food1.to_s.gsub("1)","").strip
      food2 = food2.to_s.gsub("2)","").strip
      food3 = food3.to_s.gsub("3)","").strip
      food4 = food4.to_s.gsub("4)","").strip
      food5 = food5.to_s.gsub("5)","").strip
    end
  end

  def get_mlyn(url)
    days = %w(Pondelok Utorok Streda Stvrtok Piatok)
    day_num = Time.now.wday - 1
    if day_num >= 0 && day_num <= 4
      page = open_page(url)
      nodes = page.xpath('//span[contains(.,"' + days[day_num] + '")]/following-sibling::*')
      if nodes.length > 3
        soup = nodes[1].text
        soup_text = soup[soup.index(":")+1..-1].strip

        food = nodes[3].text
        foods = food.split('2.')
        food_text =foods[0][foods[0].index(":")+2..-1].strip
        unless food[1].nil?
          food_text =foods[1]
        end
      end
    end
  end

  def get_presto(url)
    page = open_page(url)
    node = page.xpath('//div[(@class="texthelpods") and (contains(., "polievky"))]').first

    if node.children().count() >= 30
      soup1 = node.children[3]
      soup2 = node.children[6]

      food1 = node.children[9]
      food2 = node.children[12]
      food3 = node.children[15]
      food4 = node.children[18]
      food5 = node.children[21]
    end
  end

  def get_siteat(url)
    page = open_page(url)
    node = page.xpath('//div[(@class="texthelpods") and (contains(., "polievky"))]').first

    if node.children.count >= 30
      soup1 = node.children[18]
      soup2 = node.children[21]

      food1 = node.children[24]
      food2 = node.children[27]
      food3 = node.children[30]
      food4 = node.children[33]
    end
  end
end
