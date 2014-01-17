class Order < ActiveRecord::Base
  attr_accessible :menu_item_id
  
  has_many :menu_items
  belongs_to :user
end
