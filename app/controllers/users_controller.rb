class UsersController < ApplicationController
  before_action :check_admin_privileges!, only: :new

  def new
  	@user = User.new
    @password = SecureRandom.hex
  end

  def create
	  @user = User.new(user_params)
	  if @user.save
      UserMailer.registration_confirmation(@user).deliver
      flash[:success] = "Verification Email sent"
	    redirect_to root_url
	  else
	    render "new"
	  end
	end

  # def reset_password
  #   @user = User.new
  # end

  # def send_password_reset
  #   @user = User.find_by_email(params[:user][:email])
  #   if @user
  #     UserMailer.reset_password(@user).deliver
  #     flash[:success] = "An Email is sent to the provided email id"
  #     redirect_to root_url
  #   else
  #     @user = User.new
  #     flash[:notice] = "User with the provided email not found"
  #     render "reset_password"
  #   end
  # end

  def confirm_email
    user = User.find_by_confirm_token(params[:id])
    if user
      redirect_to new_password_user_path(user.id, params[:id])
    else
      flash[:error] = "Sorry. User does not exist"
      redirect_to root_url
    end
  end

  def new_password
    user = User.find_by_confirm_token(params[:format]) == User.find(params[:id]) if params[:format]
    flash[:notice] =  "Welcome to the Chat App! Your email has been confirmed. Please change the password to proceed" if user
    if user || (current_user and current_user.id.to_s == params[:id])
      @user = User.find(params[:id])
    else
      redirect_to root_path
      flash[:notice] = "You dont have access to the page"
    end
  end

  def change_password
    @user = User.find(params[:id])
    if @user.update_attributes(:password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
      @user.email_activate
      flash[:success] = "Your password is changed."
      redirect_to new_session_path
    else
      render "new_password"
    end
  end

  private
  def user_params
  	params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :mobile)
  end

end
