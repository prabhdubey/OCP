class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

 before_filter :configure_devise_params, if: :devise_controller?
  def configure_devise_params
    
	 devise_parameter_sanitizer.permit(:sign_up, keys:[:first_name, :last_name, :email,:college_name,:avatar, :password, :password_confirmation])     
 
    
  end

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  end

end
