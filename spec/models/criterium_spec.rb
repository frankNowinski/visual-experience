require "rails_helper"

describe Criterium do
  describe 'validations' do
    it { should validate_presence_of(:criteria_type) }
    it { should validate_inclusion_of(:operand).in_array(Criterium::OPERANDS).allow_nil}
    it { should validate_numericality_of(:order).is_greater_than(0) }
    it { should define_enum_for(:criteria_type) }
    it { should belong_to(:parent).class_name("Criterium").optional }
  end
end

