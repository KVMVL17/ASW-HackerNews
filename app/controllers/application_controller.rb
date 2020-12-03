class ApplicationController < ActionController::Base
  helper_method :logged_in?, :current_user
  protect_from_forgery unless: -> { request.format.json? }

  def logged_in?
    !session[:user].nil?
  end
end