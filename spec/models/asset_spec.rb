require "rails_helper"

describe Asset do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:campaign) }
  end
end

