class AddMoreFieldsToClientApplications < ActiveRecord::Migration
  def self.up
    add_column :client_applications, :description, :text
    add_column :client_applications, :avatar_url, :string
    add_column :client_applications, :is_public, :boolean
  end

  def self.down
    remove_column :client_applications, :is_public
    remove_column :client_applications, :avatar_url
    remove_column :client_applications, :description
  end
end
