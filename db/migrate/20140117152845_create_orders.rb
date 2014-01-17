class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :menu_item_id

      t.timestamps
    end
  end
end
