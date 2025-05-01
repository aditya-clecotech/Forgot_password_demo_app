class PasswordResetsController < ApplicationController
  def new
  end

  def create
    if @user = User.find_by_email_address(params[:email_address])
      PasswordMailer.with(user: @user).reset.deliver_later
    end
    redirect_to new_session_path, notice: 'If an account with that email was found, we have sent a link to reset password'
  end

  def edit
    @user = User.find_signed!(params[:token], purpose: 'password_reset')
    rescue ActiveSupport::MessageVerifier::InvalidSignature
    redirect_to new_session_path , flash[:alert] =  'Your token has expired. Please try again'
  end

  def update
    @user = User.find_signed!(params[:token], purpose: 'password_reset')
    
    if @user.update(password_params)
      redirect_to new_session_path, notice: 'Your password was reset succesfully. Please sign in.'
    else
      flash[:alert] = @user.errors.full_messages[0]
      render :edit
    end

    rescue ActiveSupport::MessageVerifier::InvalidSignature
      redirect_to new_session_path, flash[:alert] = 'Your token has expired. Please try again'
  end

  private 

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

end
