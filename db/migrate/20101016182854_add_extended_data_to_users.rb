class AddExtendedDataToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :photo, :string
    add_column :users, :verified_email, :string
    add_column :users, :service_provider, :string
    add_column :users, :url, :string
  end

  def self.down
    remove_column :users, :url
    remove_column :users, :service_provider
    remove_column :users, :verified_email
    remove_column :users, :photo
  end
end
