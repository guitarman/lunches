class SoupsController < ApplicationController

  def show
    @soup = Soup.find_by_name(params[:id])

    respond_to do |format|
      format.html #show.html.erb
      format.xml { render :xml => @soup }
    end
  end
end
