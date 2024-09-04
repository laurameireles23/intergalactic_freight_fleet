# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contract, type: :model do
  describe 'validations' do
    let(:resource) do
      Resource.create(
        name: 'Resource name',
        weight: 10
      )
    end

    let(:pilot) do
      Pilot.new(
        pilot_certification: '123456-x',
        name: 'John Doe',
        age: 35,
        credits: 100,
        location_planet: 'Earth'
      )
    end

    let(:valid_contract) do
      Contract.new(
        description: 'Contract description',
        origin_planet: 'Earth',
        destination_planet: 'Mars',
        value: 1000,
        status: :pending,
        resource: resource,
        pilot: pilot
      )
    end

    let(:invalid_contract) do
      Contract.new(
        description: '',
        origin_planet: '',
        destination_planet: '',
        value: nil,
        status: nil,
        resource: nil,
        pilot: nil
      )
    end

    it 'is valid with valid attributes' do
      expect(valid_contract).to be_valid
    end

    it 'is not valid without a description' do
      invalid_contract.description = nil
      expect(invalid_contract).to_not be_valid
    end

    it 'is not valid without an origin planet' do
      invalid_contract.origin_planet = nil
      expect(invalid_contract).to_not be_valid
    end

    it 'is not valid without a destination planet' do
      invalid_contract.destination_planet = nil
      expect(invalid_contract).to_not be_valid
    end

    it 'is not valid without a value' do
      invalid_contract.value = nil
      expect(invalid_contract).to_not be_valid
    end

    it 'is not valid without a status' do
      invalid_contract.status = nil
      expect(invalid_contract).to_not be_valid
    end

    it 'is not valid without a resource' do
      invalid_contract.resource = nil
      expect(invalid_contract).to_not be_valid
    end

    it 'is not valid without a pilot' do
      invalid_contract.pilot = nil
      expect(invalid_contract).to_not be_valid
    end
  end

  describe 'enums' do
    it 'defines the correct statuses' do
      expect(Contract.statuses).to eq({'pending' => 0, 'in_progress' => 1, 'completed' => 2, 'canceled' => 3})
    end
  end
end
