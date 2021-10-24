class Asset < ApplicationRecord
  belongs_to :campaign

  has_many :criteria, -> { where(criteria: { parent_id: nil }).order("criteria.order asc") }, dependent: :delete_all

  validates_presence_of :name, :campaign
end
