class User < ActiveRecord::Base
  has_many :client_applications
  has_many :tokens, :class_name=>"OauthToken",:order=>"authorized_at desc",:include=>[:client_application]
  has_many :activities, :dependent => :destroy
  # verbs and object types created by the user
  has_many :verbs
  has_many :object_types
  
  validates_uniqueness_of :email
  validates_presence_of :email, :on => :update
  validates_presence_of :name, :on => :update  
  
  after_update :create_first_activity

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :trackable, :database_authenticatable, :registerable,
         :recoverable, :rememberable #, :rpx_connectable
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :rpx_identifier, :photo, :service_provider, :url, :verified_email
  attr_accessible :name, :country

  def update_with_password(params={}) 
    if params[:password].blank? 
      params.delete(:password) 
      params.delete(:password_confirmation) if params[:password_confirmation].blank? 
    end 
    update_attributes(params) 
  end
  
  def avatar_url
    view = ActionView::Base.new(Rails::Application.instance.config.view_path)
    view.extend Rails.application.routes.url_helpers
    view.extend ApplicationHelper
    return view.gravatar_url_for(self.email)
  end
  
  def create_first_activity
    if self.is_first_login? and self.name.present?
      activity = self.activities.new
      activity.verb = "http://manybotsschema/1.0/join"
      
      # GENERATOR
      activity.generator_title = "Manybots"
      activity.generator_url = "http://manybots.com"

      # SERVICE PROVIDER
      activity.service_provider_name = "Manybots Server"
      #activity.service_provider_icon = item[:serviceProvider][:icon]
      activity.service_provider_uri = "http://manybots.com"
      
      # PROPERTIES
      activity.posted_time = self.created_at
      activity.tag_list = 'manybots, account'
      activity.title = "ACTOR joined OBJECT."      
      activity.url_id = "http://manybots.com/account"
      activity.summary = "Welcome to Manybots Server"
      
      # ACTOR 
      activity.actor = Actor.new
      activity.actor.title = self.name
      activity.actor.url_id = "http://manybots.com/account"

      # OBJECT
      activity.object = Obj.new
      activity.object.title = "Manybots Server"
      activity.object.url_id = "http://manybots.com"
      activity.object.object_type = "http://manybotsschema/1.0/service"

      activity.auto_title!
      activity.save
      
      self.is_first_login = false
      self.save
    end
  end
  
  protected
    
    def require_profile_update 
      redirect_to '/account'
    end
end
