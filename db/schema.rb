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

ActiveRecord::Schema.define(version: 20160120075504) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "operators", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "region_id"
    t.boolean  "connection_type"
    t.integer  "pack_type"
  end

  create_table "packs", force: :cascade do |t|
    t.integer  "region_id"
    t.integer  "operator_id"
    t.string   "price"
    t.string   "offer"
    t.string   "validity"
    t.text     "description"
    t.text     "tag"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.boolean  "connection_type"
    t.integer  "pack_type"
    t.string   "caty"
  end

  create_table "prlinks", force: :cascade do |t|
    t.integer  "region_id"
    t.integer  "operator_id"
    t.string   "link1"
    t.string   "link2"
    t.string   "link3"
    t.string   "link4"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "regions", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tests", force: :cascade do |t|
    t.string   "name"
    t.string   "phone"
    t.integer  "age"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
