class CreateTemplates < ActiveRecord::Migration[8.0]
  def change
    create_table :templates do |t|
      t.string :name, null: false
      t.string :category
      t.text :description
      t.text :html_content, null: false
      t.text :css_content
      t.text :js_content
      t.json :customizable_fields # Store field definitions as JSON
      t.string :preview_image_url
      t.boolean :active, default: true
      t.decimal :price_cents, precision: 10, scale: 2, default: 0

      t.timestamps
    end

    add_index :templates, :category
    add_index :templates, :active
  end
end