class Campaign < ApplicationRecord
  belongs_to :user

  has_many :assets, dependent: :delete_all

  validates_presence_of :name, :user
end
