# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resource, type: :model do
  describe 'validations' do
    let(:valid_resource) do
      Resource.new(
        name: 'Resource Name',
        weight: 500
      )
    end

    let(:invalid_resource) do
      Resource.new(
        name: '',
        weight: nil
      )
    end

    it 'is valid with valid attributes' do
      expect(valid_resource).to be_valid
    end

    it 'is not valid without a name' do
      invalid_resource.name = nil
      expect(invalid_resource).to_not be_valid
    end

    it 'is not valid without a weight' do
      invalid_resource.weight = nil
      expect(invalid_resource).to_not be_valid
    end
  end
end
