class MenuItem < ActiveRecord::Base
  attr_accessible :name, :price, :restaurant_id
  
  belongs_to :order
end
