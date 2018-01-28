class SessionsController < ApplicationController
	def new
	end

  def create
	  @user = User.find_by(email: login_params[:email])
	  if @user && @user.authenticate(login_params[:password])
	  	if @user.email_confirmed
		    session[:user_id] = @user.id
		    redirect_to root_url
		else
	        flash.now[:error] = 'Please activate your account by following the 
	        instructions in the account confirmation email you received and change the password to proceed'
	        render 'new'
      	end
	  else
	    flash.now.alert = "Invalid email or password"
	    render "new"
	  end
	end

	def destroy
	  session.destroy
	  redirect_to root_url, :notice => "Logged out!"
	end

	private  
	def login_params
		params.permit(:email, :password)
	end

end
