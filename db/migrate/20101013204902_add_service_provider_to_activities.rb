class AddServiceProviderToActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :service_provider_name, :string
    add_column :activities, :service_provider_icon, :string
    add_column :activities, :service_provider_uri, :string
  end

  def self.down
    remove_column :activities, :service_provider_uri
    remove_column :activities, :service_provider_icon
    remove_column :activities, :service_provider_name
  end
end
