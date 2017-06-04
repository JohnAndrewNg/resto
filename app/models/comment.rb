class Comment < ApplicationRecord

  validates :restaurant_id, :presence => true
  validates :user_id, :presence => true
  validates :body, :presence => true, :unless => :photo?
  validates :photo, :presence => true, :unless => :body?

  belongs_to :user
  belongs_to :restaurant

end
