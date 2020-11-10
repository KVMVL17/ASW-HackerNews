class ApplicationController < ActionController::Base
  helper_method :logged_in?, :current_user

  def logged_in?
    !session[:user].nil?
  end
end