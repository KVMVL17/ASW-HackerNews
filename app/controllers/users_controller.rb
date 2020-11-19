class UsersController < ApplicationController
  before_action :authenticate_user!,only: [:myprofile,:updateprofile]
  def show
    @user = User.find(params[:id])
  end
  
  def index 
    @users = User.all 
  end
  
  def userprofile
    @user = User.where(email: params[:user_id]).first
    render "userprofile"
  end
  
  def myprofile
    @updateduser = User.new
    @user = User.find(current_user.id)
    render "myprofile"
  end

  def updateprofile
    @updateduser = User.new(userupdated_params)
    @user = User.find(current_user.id)
    @user.about = @updateduser.about
    @user.save
    respond_to do |format|
      format.html { redirect_to "/myprofile", notice: 'Profile was successfully updated.' }
      format.json { head :no_content }
    end
  end

  def userupdated_params
      params.require(:user).permit(:about)
  end
end