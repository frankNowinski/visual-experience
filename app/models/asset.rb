class Asset < ApplicationRecord
  belongs_to :campaign

  has_many :criteria, -> { order("criteria.order asc") }

  validates_presence_of :name, :campaign
end
