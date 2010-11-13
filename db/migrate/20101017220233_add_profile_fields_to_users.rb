class AddProfileFieldsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :name, :string
    add_column :users, :avatar_source, :string
    add_column :users, :avatar_url, :string
    add_column :users, :country, :string
  end

  def self.down
    remove_column :users, :country
    remove_column :users, :avatar_url
    remove_column :users, :avatar_source
    remove_column :users, :name
  end
end
