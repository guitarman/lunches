# encoding: utf-8
class UsersController < ApplicationController
  #force_ssl :only => [:edit, :update]
  before_filter :authenticate, :only => [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to login_path, :notice => "Používateľ bol úspešne zaregistrovaný, môžeš sa prihlásiť"
    else
      render :action => 'new'
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to settings_path, :notice => "Údaje boli úspešne aktualizované"
    else
      render :action => 'edit'
    end
  end
end
