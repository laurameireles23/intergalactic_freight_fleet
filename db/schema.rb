# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_09_03_190935) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contracts", force: :cascade do |t|
    t.string "description"
    t.string "origin_planet"
    t.string "destination_planet"
    t.integer "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "payload_id"
    t.index ["payload_id"], name: "index_contracts_on_payload_id"
  end

  create_table "pilots", force: :cascade do |t|
    t.string "pilot_certification"
    t.string "name"
    t.integer "age"
    t.integer "credits"
    t.string "location_planet"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "ship_id"
    t.index ["ship_id"], name: "index_pilots_on_ship_id"
  end

  create_table "resources", force: :cascade do |t|
    t.string "name"
    t.integer "weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ships", force: :cascade do |t|
    t.integer "fuel_capacity"
    t.integer "fuel_level"
    t.integer "weight_capacity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "pilot_id"
    t.index ["pilot_id"], name: "index_ships_on_pilot_id"
  end

  add_foreign_key "contracts", "resources", column: "payload_id"
  add_foreign_key "pilots", "ships"
  add_foreign_key "ships", "pilots"
end
