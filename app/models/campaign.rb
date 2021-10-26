class Campaign < ApplicationRecord
  belongs_to :user

  has_many :assets

  validates_presence_of :name, :user

  accepts_nested_attributes_for :assets

  def duplicate
    deep_clone include: [ assets: { criteria: :nested_criteria } ]
  end
end
