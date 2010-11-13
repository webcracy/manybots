# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101110160410) do

  create_table "activities", :force => true do |t|
    t.integer  "user_id"
    t.integer  "client_application_id"
    t.string   "url_id"
    t.string   "verb"
    t.string   "stream_favicon_url"
    t.string   "generator_url"
    t.string   "generator_title"
    t.text     "title",                 :limit => 255
    t.text     "summary"
    t.string   "lang"
    t.datetime "posted_time"
    t.string   "permalink"
    t.boolean  "is_public"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "service_provider_name"
    t.string   "service_provider_icon"
    t.string   "service_provider_uri"
  end

  add_index "activities", ["client_application_id"], :name => "index_activities_on_client_application_id"
  add_index "activities", ["user_id"], :name => "index_activities_on_user_id"

  create_table "activity_objects", :force => true do |t|
    t.integer  "activity_id"
    t.string   "type"
    t.string   "url_id"
    t.string   "title"
    t.datetime "posted_time"
    t.string   "object_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activity_objects", ["activity_id"], :name => "index_activity_objects_on_activity_id"
  add_index "activity_objects", ["type"], :name => "index_activity_objects_on_type"

  create_table "client_applications", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "support_url"
    t.string   "callback_url"
    t.string   "key",          :limit => 40
    t.string   "secret",       :limit => 40
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.string   "avatar_url"
    t.boolean  "is_public"
  end

  add_index "client_applications", ["key"], :name => "index_client_applications_on_key", :unique => true

  create_table "contacts", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.text     "message"
    t.string   "subject"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "oauth_nonces", :force => true do |t|
    t.string   "nonce"
    t.integer  "timestamp"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_nonces", ["nonce", "timestamp"], :name => "index_oauth_nonces_on_nonce_and_timestamp", :unique => true

  create_table "oauth_tokens", :force => true do |t|
    t.integer  "user_id"
    t.string   "type",                  :limit => 20
    t.integer  "client_application_id"
    t.string   "token",                 :limit => 40
    t.string   "secret",                :limit => 40
    t.string   "callback_url"
    t.string   "verifier",              :limit => 20
    t.string   "scope"
    t.datetime "authorized_at"
    t.datetime "invalidated_at"
    t.datetime "valid_to"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_tokens", ["token"], :name => "index_oauth_tokens_on_token", :unique => true

  create_table "object_types", :force => true do |t|
    t.string   "name"
    t.string   "url_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_public",  :default => false
    t.integer  "user_id"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "",   :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "",   :null => false
    t.string   "password_salt",                       :default => "",   :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "rpx_identifier"
    t.string   "photo"
    t.string   "verified_email"
    t.string   "service_provider"
    t.string   "url"
    t.string   "name"
    t.string   "avatar_source"
    t.string   "avatar_url"
    t.string   "country"
    t.boolean  "is_first_login",                      :default => true
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "verbs", :force => true do |t|
    t.string   "name"
    t.string   "url_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_public",  :default => false
    t.integer  "user_id"
  end

end
