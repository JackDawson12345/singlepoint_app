class CreateWebsitePages < ActiveRecord::Migration[8.0]
  def change
    create_table :website_pages do |t|
      t.references :website, null: false, foreign_key: true
      t.string :name, null: false
      t.string :slug, null: false
      t.text :html_content
      t.text :css_content
      t.text :js_content
      t.json :page_customizations
      t.integer :sort_order, default: 0
      t.boolean :is_homepage, default: false

      t.timestamps
    end

    add_index :website_pages, [:website_id, :slug], unique: true
    add_index :website_pages, :sort_order
  end
end