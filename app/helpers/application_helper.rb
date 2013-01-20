# encoding: utf-8
module ApplicationHelper
  def day_name_and_date
    days = %w(pondelok utorok streda štvrtok piatok sobota nedeľa)
    days[DateTime.now.wday - 1] + ', ' + DateTime.now.strftime('%d. %m. %Y')
  end
end
