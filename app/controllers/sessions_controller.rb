# encoding: utf-8
class SessionsController < ApplicationController
  #force_ssl
  before_filter :authenticate, :only => :destroy

  def create
    if (user = User.authenticate(params[:email], params[:password]))
      session[:user_id] = user.id
      redirect_to root_path, :notice => "Bol si prihlásený"
    else
      flash.now[:alert] = "Nesprávne zadaný email alebo heslo"
      render :action => 'new'
    end
  end

  def destroy
    reset_session
    redirect_to root_path, :notice => "Bol si odhlásený"
  end
end
