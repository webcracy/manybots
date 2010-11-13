class AppsController < ApplicationController
  before_filter :login_required
  def index
    @apps = ClientApplication.where({:is_public => true})
    @client_applications = current_user.client_applications
    @tokens = current_user.tokens.where('oauth_tokens.invalidated_at is null and oauth_tokens.authorized_at is not null')
  end
  
  def show
    @client_application = current_user.client_applications.find_by_id(params[:id])
    render 'oauth_clients/show'
  end
  
end
