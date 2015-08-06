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

ActiveRecord::Schema.define(version: 20150721095241) do

  create_table "invited_friends", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "email"
    t.string   "invite_token"
    t.datetime "invite_last_send_at"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "invited_friends", ["email"], name: "index_invited_friends_on_email", unique: true
  add_index "invited_friends", ["invite_token"], name: "index_invited_friends_on_invite_token", unique: true
  add_index "invited_friends", ["user_id"], name: "index_invited_friends_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                       null: false
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "activation_state"
    t.string   "activation_token"
    t.datetime "activation_token_expires_at"
    t.string   "invited_user_id"
  end

  add_index "users", ["activation_token"], name: "index_users_on_activation_token"
  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
