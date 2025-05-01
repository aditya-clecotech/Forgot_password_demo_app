class PasswordMailer < ApplicationMailer

  def reset
    @user = params[:user]
    @token = @user.signed_id(purpose: "password_reset", expires_in: 10.minutes)

    mail to: @user.email_address, subject: "Password reset instruction"
  end

end
