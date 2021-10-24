class Campaign < ApplicationRecord
  belongs_to :user

  has_many :assets

  validates_presence_of :name, :user
end
