class AllowNullDomainInOrders < ActiveRecord::Migration[8.0]
  def change
    change_column_null :orders, :domain_id, true
  end
end
