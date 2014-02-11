class AddIndexToRestaurantsEmail < ActiveRecord::Migration
  def change
    add_index :restaurants, :email, unique: true
  end
end
