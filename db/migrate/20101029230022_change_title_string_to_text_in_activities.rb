class ChangeTitleStringToTextInActivities < ActiveRecord::Migration
  def self.up
    change_column :activities, :title, :text
  end

  def self.down
    change_column :activities, :title, :string
  end
end
