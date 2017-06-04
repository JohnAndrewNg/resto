class Favorite < ApplicationRecord

  validates :restaurant_id, :presence => true
  validates :user_id, :presence => true, :uniqueness => { :scope => :restaurant }

  belongs_to :user
  belongs_to :restaurant

end
