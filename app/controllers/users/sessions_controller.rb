class Users::SessionsController < Devise::SessionsController
  
  def after_sign_out_path_for(_resource_or_scope)
    session.delete(:user_id)
    @current_user = nil
    root_path
  end

  def after_sign_in_path_for(resource_or_scope)
    user_info = request.env["omniauth.auth"]

    user           = User.new
    user.id        = user_info["uid"]
    user.name      = user_info["info"]["name"]
    
    
    session[:user_id] = @user.id
    @current_user = @user_id
    redirect_to root_path
  end
end