class SessionsController < ApplicationController
   def new 
   end

   def create 
      @user = User.find_by(email_address: params[:email_address])

      if @user.nil?
         flash[:alert] = "invalid email, user not found!!!"
         redirect_to root_path and return
      end
      
      # checking that user account is locked or not

      if @user.locked?       
         if @user.locked_at_expired?
            @user.unlock!
         else         
            flash[:alert] = "Your account is locked. Try again after 15 minutes"         
            redirect_to root_path and return 
         end 
      end


      if @user&.authenticate(params[:password])
         session[:user_id] = @user.id
         redirect_to root_path, notice: "Logged in successfully"
      else      
         @user.register_failed_attempts!

         flash[:alert] = "Invalid email or password"
         render :new 
      end 
   end

   def destroy 
      session[:user_id] = nil
      redirect_to root_path, notice: "Logged out successfully"
   end

end