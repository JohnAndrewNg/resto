class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :username, :presence => true, :uniqueness => true
  validates :location, :presence => true


  has_many :favorites, :dependent => :destroy
  has_many :following_connections, :class_name => "Connection", :foreign_key => "follower_id", :dependent => :destroy
  has_many :follower_connections, :class_name => "Connection", :foreign_key => "leader_id", :dependent => :destroy
  has_many :comments, :dependent => :destroy

  has_many :leaders, :through => :following_connections, :source => :leader
  has_many :followers, :through => :follower_connections, :source => :follower
  has_many :favorite_restaurants, :through => :favorites, :source => :restaurant
  has_many :timeline_favorites, :through => :leaders, :source => :favorite_restaurants

end
