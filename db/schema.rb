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

ActiveRecord::Schema.define(version: 20150723010019) do

  create_table "stock_values", force: :cascade do |t|
    t.string   "br_date"
    t.date     "us_date"
    t.float    "value"
    t.float    "variance"
    t.float    "variancepercent"
    t.float    "low"
    t.float    "high"
    t.integer  "volume"
    t.integer  "stock_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "stock_values", ["stock_id"], name: "index_stock_values_on_stock_id"

  create_table "stocks", force: :cascade do |t|
    t.text     "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "updates", force: :cascade do |t|
    t.boolean  "updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
