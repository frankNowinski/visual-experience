class Criterium < ApplicationRecord
  belongs_to :asset
  belongs_to :parent, class_name: "Criterium", optional: true

  has_many :criteria, class_name: "Criterium", foreign_key: :parent_id

  enum criteria_type: { device: 0, nested: 1, always: 2 }

  validates_presence_of :criteria_type
end
