# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_09_26_175641) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "transportations", force: :cascade do |t|
    t.bigint "from_city_id", null: false
    t.bigint "to_city_id", null: false
    t.string "means"
    t.integer "price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "npc_name"
    t.index ["from_city_id"], name: "index_transportations_on_from_city_id"
    t.index ["to_city_id"], name: "index_transportations_on_to_city_id"
  end

  add_foreign_key "transportations", "cities", column: "from_city_id"
  add_foreign_key "transportations", "cities", column: "to_city_id"
end
