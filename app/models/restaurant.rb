class Restaurant < ApplicationRecord

  validates :placeid, :presence => true
  validates :name, :presence => true
  validates :latitude, :presence => true
  validates :longitude, :presence => true

  has_many :favorites, :dependent => :destroy
  has_many :comments, :dependent => :destroy

  has_many :fans, :through => :favorites, :source => :user
  has_many :timeline_fans, :through => :fans, :source => :leaders

end
