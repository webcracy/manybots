class AddUserIdAndIsPublicToVerbsAndObjectTypes < ActiveRecord::Migration
  def self.up
    add_column :verbs, :is_public, :boolean, :default => false
    add_column :verbs, :user_id, :integer
    add_column :object_types, :is_public, :boolean, :default => false
    add_column :object_types, :user_id, :integer
  end

  def self.down
    remove_column :object_types, :user_id
    remove_column :object_types, :is_public
    remove_column :verbs, :user_id
    remove_column :verbs, :is_public
  end
end
