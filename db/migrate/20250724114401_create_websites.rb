class CreateWebsites < ActiveRecord::Migration[8.0]
  def change
    create_table :websites do |t|
      t.references :user, null: false, foreign_key: true
      t.references :template, null: false, foreign_key: true
      t.references :domain, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description
      t.json :customizations # Store user customizations as JSON
      t.text :compiled_html # Final compiled HTML
      t.text :compiled_css
      t.text :compiled_js
      t.string :status, default: 'draft' # draft, published, archived
      t.datetime :published_at

      t.timestamps
    end

    add_index :websites, :status
    add_index :websites, :published_at
  end
end