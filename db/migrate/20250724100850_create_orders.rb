class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :domain, null: false, foreign_key: true
      t.string :package_type
      t.string :implementation_type
      t.integer :step, default: 1
      t.integer :amount_cents
      t.string :stripe_payment_intent_id
      t.string :status, default: 'pending'

      t.timestamps
    end


  end
end
