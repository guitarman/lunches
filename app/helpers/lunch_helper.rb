# encoding: UTF-8
module LunchHelper
  def days_navigation
    day_names = %w(Pondelok Utorok Streda Štvrtok Piatok Sobota Nedeľa)

    content_tag :div, :class => "days_navigation" do
      start_date = date_of_previous_monday(@date)

      day_names.each_with_index do |day_name, i|
          concat(day(day_name, start_date, i == selected_wday(@date) ? true : false))
          start_date += 1.day
      end
    end
  end

  def day(day_name, date, selected)
    content_tag :div, :class => selected ? "selected_day" : "day" do
      content_tag :a, :href => "/" + date.strftime("%Y-%m-%d")  do
        (day_name + tag('br') + date.strftime("%d.%m.%Y")).html_safe
      end
    end
  end

  def date_of_previous_monday(date)
    date - selected_wday(date)
  end

  def selected_wday(date)
    date.wday == 0 ? 6 : date.wday - 1
  end
end
