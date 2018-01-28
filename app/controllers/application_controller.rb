class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?

	private

	def current_user
	  @current_user ||= User.find(session[:user_id]) if session[:user_id]
	end

	def logged_in?
		current_user != nil
	end

	protected

	def check_admin_privileges!
    if current_user 
      redirect_to root_path, notice: 'You dont have enough permissions to be there' unless current_user.role == 'admin'
    else
    	redirect_to root_path, notice: 'Please Login'
    end
  end
end
