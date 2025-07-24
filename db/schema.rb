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

ActiveRecord::Schema[8.0].define(version: 2025_07_24_114429) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "domains", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_domains_on_user_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "domain_id"
    t.string "package_type"
    t.string "implementation_type"
    t.integer "step", default: 1
    t.integer "amount_cents"
    t.string "stripe_payment_intent_id"
    t.string "status", default: "pending"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["domain_id"], name: "index_orders_on_domain_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "templates", force: :cascade do |t|
    t.string "name", null: false
    t.string "category"
    t.text "description"
    t.text "html_content", null: false
    t.text "css_content"
    t.text "js_content"
    t.json "customizable_fields"
    t.string "preview_image_url"
    t.boolean "active", default: true
    t.decimal "price_cents", precision: 10, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_templates_on_active"
    t.index ["category"], name: "index_templates_on_category"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "website_pages", force: :cascade do |t|
    t.bigint "website_id", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.text "html_content"
    t.text "css_content"
    t.text "js_content"
    t.json "page_customizations"
    t.integer "sort_order", default: 0
    t.boolean "is_homepage", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sort_order"], name: "index_website_pages_on_sort_order"
    t.index ["website_id", "slug"], name: "index_website_pages_on_website_id_and_slug", unique: true
    t.index ["website_id"], name: "index_website_pages_on_website_id"
  end

  create_table "websites", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "template_id", null: false
    t.bigint "domain_id", null: false
    t.string "title", null: false
    t.text "description"
    t.json "customizations"
    t.text "compiled_html"
    t.text "compiled_css"
    t.text "compiled_js"
    t.string "status", default: "draft"
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["domain_id"], name: "index_websites_on_domain_id"
    t.index ["published_at"], name: "index_websites_on_published_at"
    t.index ["status"], name: "index_websites_on_status"
    t.index ["template_id"], name: "index_websites_on_template_id"
    t.index ["user_id"], name: "index_websites_on_user_id"
  end

  add_foreign_key "domains", "users"
  add_foreign_key "orders", "domains"
  add_foreign_key "orders", "users"
  add_foreign_key "website_pages", "websites"
  add_foreign_key "websites", "domains"
  add_foreign_key "websites", "templates"
  add_foreign_key "websites", "users"
end
