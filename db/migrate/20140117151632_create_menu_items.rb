class CreateMenuItems < ActiveRecord::Migration
  def change
    create_table :menu_items do |t|
      t.string :name
      t.integer :price
      t.integer :restaurant_id

      t.timestamps
    end
  end
end
