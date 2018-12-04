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

ActiveRecord::Schema.define(version: 2018_11_24_135821) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "message_adapters", force: :cascade do |t|
    t.string "msgid", null: false
    t.string "title"
    t.string "status"
    t.string "state"
    t.string "message_type"
    t.integer "created_by", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["msgid"], name: "index_message_adapters_on_msgid", unique: true
  end

  create_table "message_histories", force: :cascade do |t|
    t.string "msgid"
    t.string "row"
    t.string "message_type"
    t.string "status"
    t.text "note"
    t.text "note2"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["msgid", "row"], name: "index_message_histories_on_msgid_and_row"
  end

  create_table "user_contacts", force: :cascade do |t|
    t.bigint "user_id"
    t.string "contact_detail"
    t.integer "contact_type"
    t.string "contact_sub"
    t.text "contact_note"
    t.index ["user_id"], name: "index_user_contacts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "personid"
    t.string "cardid"
    t.string "full_name"
    t.string "full_name_transcription"
    t.datetime "expired_at"
    t.date "registration_date"
    t.text "note"
    t.integer "number_of_reminder"
    t.boolean "deactive", default: false, null: false
    t.datetime "deactive_at"
    t.index ["cardid"], name: "index_users_on_cardid"
    t.index ["deactive"], name: "index_users_on_deactive"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["personid"], name: "index_users_on_personid", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

end
