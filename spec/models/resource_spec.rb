# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resource, type: :model do
  describe 'validations' do
    let(:valid_resource) { Resource.new(name: 'water', weight: 500) }
    let(:invalid_resource) { Resource.new(name: 'invalid', weight: 12) }

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

    context 'when the resource name is valid' do
      it 'is valid with a valid name' do
        valid_resource.name = 'water'
        expect(valid_resource).to be_valid
      end

      it 'is valid with another valid name' do
        valid_resource.name = 'minerals'
        expect(valid_resource).to be_valid
      end

      it 'is valid with a third valid name' do
        valid_resource.name = 'food'
        expect(valid_resource).to be_valid
      end
    end

    context 'when the resource name is invalid' do
      it 'is not valid with an invalid name' do
        expect(invalid_resource).to_not be_valid
      end

      it 'adds an error for invalid name' do
        invalid_resource.valid?
        expect(invalid_resource.errors[:name]).to include('is not included in the list')
      end
    end
  end
end
