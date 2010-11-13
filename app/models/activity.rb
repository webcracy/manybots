class Activity < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  default_url_options[:host] = "localhost:3000"
  
  acts_as_taggable
  
  attr_accessible :user
  attr_accessible :url_id, :posted_time, :verb, :title, :summary, :lang
  attr_accessible :actor_attributes, :target_attributes, :object_attributes
  attr_accessible :generator_url, :generator_title
  attr_accessible :service_provider_icon, :service_provider_name, :service_provider_uri
  attr_accessible :tags, :tag_list

  has_many :activity_objects, :dependent => :destroy

  has_one :actor
  has_one :object, :class_name => 'Obj'
  has_one :target

  belongs_to :user
  
  scope :reverse, :order => 'created_at DESC'
  scope :are_public, :conditions => {:is_public => true}
  scope :filter_advanced,     lambda{ |options|
      where, arguments = [], []
      cols = Activity.column_names.collect {|c| "activities.#{c}"}.join(",")
      # actor as user
      where << "activities.user_id IN (?)" and arguments << options[:actors] if options[:actors].present?
      # verbs
      where << "activities.verb IN (?)" and arguments << options[:verbs] if options[:verbs].present?
      # object-types
      where << "(activity_objects.object_type IN (?) AND activity_objects.type='Obj')" and arguments << options[:objects] if options[:objects].present?
      # targets
      where << "(activity_objects.object_type IN (?) AND activity_objects.type='Target')" and arguments << options[:targets] if options[:targets].present?
      # where << "meet_actions.account_id IN (?) AND meet_actions.action_type = 'email'" and arguments << options[:email_accounts] unless options[:email_accounts].nil?
      # where << "meet_actions.account_id IN (?) AND meet_actions.action_type = 'twitter'" and arguments << options[:twitter_accounts] unless options[:twitter_accounts].nil?
      { :joins => [:activity_objects], :conditions => [where.join(" AND "), *arguments], :group => "#{cols}" }
  }

  validates_presence_of   :actor
  validates_presence_of   :verb
  validates_presence_of   :object
  validates_presence_of   :posted_time
  
  before_create :add_permalink

  accepts_nested_attributes_for :actor, :object, :target, :reject_if => proc { |p| p['url_id'].blank? }, :allow_destroy => true

  def self.verbs_to_select
    [
      ['POST', "http://activitystrea.ms/schema/1.0/post"],
      ['FAVORITE', "http://activitystrea.ms/schema/1.0/favorite"],
      ['FOLLOW', 'http://activitystrea.ms/schema/1.0/follow'],
      ['LIKE', 'http://activitystrea.ms/schema/1.0/like'],
      ['MAKE-FRIEND', 'http://activitystrea.ms/schema/1.0/make-friend'],
      ['JOIN', 'http://activitystrea.ms/schema/1.0/join'],
      ['PLAY', 'http://activitystrea.ms/schema/1.0/play'],
      ['SAVE', 'http://activitystrea.ms/schema/1.0/save'],
      ['SHARE', 'http://activitystrea.ms/schema/1.0/share'],
      ['TAG', 'http://activitystrea.ms/schema/1.0/tag'],
      ['UPDATE', 'http://activitystrea.ms/schema/1.0/update']
    ]
  end
  
  def self.to_calendar(activities)
    view = ActionView::Base.new(Rails::Application.instance.config.view_path)
    view.extend Rails.application.routes.url_helpers
    view.extend ApplicationHelper
    json = []
    activities.each do |activity|
      event = {}
      event[:title] = "#{activity.verb_title} a #{activity.object_title}"
      event[:title] << " in #{activity.target.title}" if activity.target
      event[:title] << ": #{activity.summary}" unless activity.summary.nil? or activity.summary.blank?
      event[:description] = view.render(:partial => 'activities/activity_calendar', :locals => {:activity => activity})
      event[:id] = activity.id
      event[:start] = activity.posted_time.to_s
      event[:end] = activity.posted_time.to_s
      event[:allDay] = false
      json.push event
    end
    return json
  end
  
  
  def self.new_from_json(params)
    item = params[:activity]
    activity = self.new
    
    # PROPERTIES
    activity.url_id = item[:id]
    activity.permalink = item[:permalinkUrl]
    activity.title = item[:title]
    activity.summary = item[:summary]
    activity.stream_favicon_url = item[:streamFaviconUrl]
    activity.posted_time = item[:posted_time]
    
    # VERB
    activity.verb = item[:verb]
    # TAGS
    activity.tag_list = item[:tags].join(', ') if item[:tags].present?
        
    # GENERATOR
    activity.generator_title = item[:generator][:name]
    activity.generator_url = item[:generator][:permalinkUrl]
    
    # SERVICE PROVIDER
    activity.service_provider_name = item[:serviceProvider][:name]
    activity.service_provider_icon = item[:serviceProvider][:icon]
    activity.service_provider_uri = item[:serviceProvider][:uri]

    # ACTOR 
    activity.actor = Actor.new
    activity.actor.title = item[:actor][:title]
    activity.actor.url_id = item[:actor][:id]
    
    # OBJECT
    activity.object = Obj.new
    activity.object.title = item[:object][:title]
    activity.object.url_id = item[:object][:id]
    activity.object.object_type = item[:object][:objectType]
    
    # TARGET
    activity.target = Target.new
    activity.target.title = item[:target][:title]
    activity.target.url_id = item[:target][:id]
    activity.target.object_type = item[:target][:objectType]
    
    return activity
  end
  
  def auto_title!
    unless self.actor.nil? or self.object.nil? 
      actor_link = "<a href="+self.actor.url_id+">#{self.actor.title}</a>"
      self.title.gsub!('ACTOR', actor_link)
      
      object_link = "<a href="+self.object.url_id+">#{self.object.title}</a>"
      self.title.gsub!('OBJECT', object_link)
    else 
      return false
    end
    
    unless self.target.nil?
      target_link = "<a href="+self.target.url_id+">#{self.target.title}</a>"
      self.title.gsub!('TARGET', target_link)
    end    
  end
  
  def verb_title
    verb.split('/').last.upcase
  end
  
  def object_title
    object.object_type.split('/').last.upcase
  end
  
  def to_json
    a = {
      :id => url_for(self),
      :permalinkUrl => url_for(self),
      :title => self.title,
      :summary => self.summary,
      :postedTime => self.posted_time.to_s(:w3cdtf),
      :tags => self.tags.collect(&:name),
      :actor => {
         :id => self.actor.url_id,
         :title => self.actor.title,
       },
       :object => {
         :id => self.object.url_id,
         :title => self.object.title,
         :objectType => self.object.object_type 
       },
       :verb => self.verb
    }
    
    if self.target.present?
      a[:target] = {
        :id => self.target.url_id,
        :title => self.target.title,
        :objectType => self.target.object_type
      }
    end
    
    return a

    # return JSON.pretty_generate({
    #   :data => {
    #     :lang => "en-US",
    #     :id => self.id,
    #     :items => [ a ]
    #   }
    # }.stringify_keys)
  end

  def to_xml
    builder = Builder::XmlMarkup.new(:indent => 2)
    builder.entry do |b|
      b.id activity_url(self)
      b.permalink activity_url(self)
      b.published self.posted_time.to_s(:w3cdtf)
      b.title self.title
      b.summary self.summary
      b.author do
        b.id self.actor.url_id
        b.title self.actor.title
      end
      b.activity :verb, self.verb
      b.activity :actor do
        b.id self.actor.url_id
        b.title self.actor.title, :type => 'text'
      end
      b.activity :object do
        b.id self.object.url_id
        b.title self.object.title, :type => 'text'
        b.activity :"object-type", self.object.object_type
      end

      if self.target.present?
        b.activity :target do
          b.id self.target.url_id
          b.title self.target.title, :type => 'text'
          b.activity :"object-type", self.target.object_type
        end
      end
    end
  end
  
  def add_permalink
    hash = hash_gen(self)
    while Activity.find_by_permalink(hash)
      self.add_permalink
    end
    self.permalink = hash
  end
  
  
  private
      
    def hash_gen(activity)
      return Digest::SHA1.hexdigest(activity.verb.to_s+activity.title.to_s+activity.summary.to_s+Time.now.to_f.to_s).to_s
    end
end
