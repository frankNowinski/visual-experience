# frozen_string_literal: true

class Criterium < ApplicationRecord
  belongs_to :asset
  belongs_to :parent, class_name: "Criterium", optional: true

  has_many :criteria, class_name: "Criterium", foreign_key: :parent_id

  enum criteria_type: { device: 0, nested: 1, always: 2 }

  IPHONE = "iphone"
  ANDROID = "android"
  WINDOWS_PHONE = "windows_phone"
  PALM_PILOT = "palm_pilot"

  OPERANDS = [IPHONE, ANDROID, WINDOWS_PHONE, PALM_PILOT]

  validates_presence_of :criteria_type
  validates_inclusion_of :operand, in: OPERANDS, allow_nil: true
  validates :operand, uniqueness: { scope: [:asset_id, :operand], allow_nil: true }
  validates :order, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
end
