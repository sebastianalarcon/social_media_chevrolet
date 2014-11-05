# encoding: UTF-8
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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141105220111) do

  create_table "media", force: true do |t|
    t.string   "id_media"
    t.string   "user"
    t.string   "text"
    t.string   "image_url"
    t.string   "approve_state"
    t.string   "show_state"
    t.string   "social_net_origin"
    t.datetime "media_created_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "media", ["id_media", "social_net_origin"], name: "index_media_on_id_media_and_social_net_origin", unique: true

  create_table "registries", force: true do |t|
    t.date     "last_registry"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
