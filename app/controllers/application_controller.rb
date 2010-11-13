require 'oauth_controllers_application_controller_methods'

class ApplicationController < ActionController::Base
  include OAuth::Controllers::ApplicationControllerMethods
  protect_from_forgery
  
  def login_required(options = {})
    authenticate_user!
  end
  
  def manybots_oauth_required
    unless user_signed_in?
      unless oauth_required
        authenticate_user!
      end
    end
  end
  
  def complete_profile
    if current_user and  current_user.name.nil?
      flash[:notice] = "Almost there. Please complete your profile before continuing."
      redirect_to '/account'
    end
  end
  
  
end
