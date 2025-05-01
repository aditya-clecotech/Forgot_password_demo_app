class UsersController < ApplicationController

  def new
    user = User.new
  end

  def create 
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id 
      redirect_to root_path, notice: "User was created and signed in successfully"
    else  
      flash[:alert] = user.errors.full_messages 
      render :new 
    end 
  end
  
  private 

  def user_params
    params.permit(:email_address, :password, :password_confirmation)
  end

end
