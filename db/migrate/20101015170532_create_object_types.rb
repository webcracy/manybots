class CreateObjectTypes < ActiveRecord::Migration
  def self.up
    create_table :object_types do |t|
      t.string :name
      t.string :url_id

      t.timestamps
    end
  end

  def self.down
    drop_table :object_types
  end
end
