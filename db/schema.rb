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

ActiveRecord::Schema.define(version: 20131214054455) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "doubles_matches", force: true do |t|
    t.integer  "winner0_id"
    t.integer  "winner1_id"
    t.integer  "loser0_id"
    t.integer  "loser1_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "score_difference"
    t.integer  "winner0_points"
    t.integer  "winner1_points"
    t.integer  "loser0_points"
    t.integer  "loser1_points"
    t.float    "winner0_sigma"
    t.float    "winner1_sigma"
    t.float    "winner0_mu"
    t.float    "winner1_mu"
    t.float    "loser0_sigma"
    t.float    "loser1_sigma"
    t.float    "loser0_mu"
    t.float    "loser1_mu"
  end

  create_table "matches", force: true do |t|
    t.integer  "winner_id"
    t.integer  "loser_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "score_difference"
    t.integer  "winner_points"
    t.integer  "loser_points"
    t.float    "winner_sigma"
    t.float    "winner_mu"
    t.float    "loser_sigma"
    t.float    "loser_mu"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "mu",             default: 25.0
    t.float    "sigma",          default: 8.333333333333334
    t.string   "email"
    t.integer  "points",         default: 0
    t.float    "doubles_mu",     default: 25.0
    t.float    "doubles_sigma",  default: 8.333333333333334
    t.integer  "doubles_points", default: 0
  end

end
