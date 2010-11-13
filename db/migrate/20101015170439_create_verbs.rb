class CreateVerbs < ActiveRecord::Migration
  def self.up
    create_table :verbs do |t|
      t.string :name
      t.string :url_id

      t.timestamps
    end
  end

  def self.down
    drop_table :verbs
  end
end
