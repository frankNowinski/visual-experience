class User < ApplicationRecord
  has_many :campaigns

  validates_presence_of :email
end
