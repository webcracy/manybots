class ObjectType < ActiveRecord::Base
  before_save :upcase_name
  
  scope :is_public, :conditions => {:is_public => true}
  
  def self.for_user(user_id)
    self.find_all_by_user_id(user_id) + self.is_public
  end
  
  def upcase_name
    self.name = self.name.upcase
    self.url_id = ManybotsServer.schema_url + "/#{self.name.downcase}"
  end
  
end
