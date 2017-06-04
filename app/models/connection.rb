class Connection < ApplicationRecord

  validates :follower_id, :presence => true
  validates :leader_id, :presence => true

  belongs_to :follower, :class_name => "User"
  belongs_to :leader, :class_name => "User"

end
