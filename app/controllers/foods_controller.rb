class FoodsController < ApplicationController

  def show
    @food = Food.find(params[:id])

    respond_to do |format|
      format.html #show.html.erb
      format.xml { render :xml => @food }
    end
  end
end
