class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.integer :user_id
      t.integer :client_application_id
      t.string :url_id
      t.string :verb
      t.string :stream_favicon_url
      t.string :generator_url
      t.string :generator_title
      t.string :title
      t.text :summary
      t.string :lang
      t.datetime :posted_time
      t.string :permalink
      t.boolean :is_public

      t.timestamps
    end
    
    add_index :activities, :user_id
    add_index :activities, :client_application_id
  end

  def self.down
    remove_index :activities
    
    drop_table :activities
  end
end
