# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_user
    return unless session[:user_id]
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def authenticate
    logged_in? ? true : access_denied
  end

  def logged_in?
    current_user.is_a? User
  end

  def access_denied
    redirect_to login_path, :alert => "Pre pokračovanie musíš byť prihlásený" and return false
  end

  helper_method :current_user
  helper_method :authenticate
  helper_method :logged_in?
end
