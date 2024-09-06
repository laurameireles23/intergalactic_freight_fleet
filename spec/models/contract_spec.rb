# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contract, type: :model do
  describe 'validations' do
    let(:resource) do
      Resource.create(
        name: 'water',
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

  describe '#can_accept_contract?' do
    let(:pilot) do
      Pilot.create(
        pilot_certification: '123456-x',
        name: 'John Doe',
        age: 35,
        credits: 0,
        location_planet: 'Andvari'
      )
    end

    let(:ship) do
      Ship.create(
        fuel_capacity: 100,
        fuel_level: 50,
        weight_capacity: 1000,
        pilot: pilot
      )
    end

    let(:resource) do
      Resource.create(
        name: 'water',
        weight: 10
      )
    end

    let(:contract) do
      Contract.create(
        description: 'Contract description',
        origin_planet: 'Andvari',
        destination_planet: 'Calas',
        value: 100,
        pilot: pilot,
        status: :pending,
        resource: resource
      )
    end

    before do
      pilot.update!(ship: ship)
    end

    context 'when the contract is acceptable' do
      it 'returns true' do
        expect(contract.can_accept_contract?(pilot)).to be true
      end
    end

    context 'when the contract is not acceptable' do
      it 'returns false if the ship cannot load the resource' do
        allow(pilot.ship).to receive(:can_load?).and_return(false)

        expect(contract.can_accept_contract?(pilot)).to be false
      end
    end
  end

  describe '#complete_contract' do
    let(:pilot) do
      Pilot.create(
        pilot_certification: '123456-x',
        name: 'John Doe',
        age: 35,
        credits: 0,
        location_planet: 'Andvari'
      )
    end

    let(:ship) do
      Ship.create!(
        fuel_capacity: 100,
        fuel_level: 50,
        weight_capacity: 1000,
        pilot: pilot
      )
    end

    let(:resource) do
      Resource.create!(
        name: 'water',
        weight: 10,
        fuel_needed: 10
      )
    end

    let(:contract) do
      Contract.create(
        description: 'Contract description',
        origin_planet: 'Andvari',
        destination_planet: 'Calas',
        value: 100,
        pilot: pilot,
        status: :pending,
        resource: resource
      )
    end

    it 'completes the contract, updates the location, and pays the pilot' do
      pilot.update!(ship_id: ship.id)

      contract.complete_contract(pilot)
      contract.reload
      pilot.reload

      expect(contract.status).to eq('completed')
      expect(pilot.credits).to eq(contract.value)
    end
  end

  describe '.generate_report' do
    let!(:pilot) do
      Pilot.create(
        pilot_certification: '123456-x',
        name: 'John Doe',
        age: 35,
        credits: 100,
        location_planet: 'Andvari'
      )
    end

    let!(:ship) do
      Ship.create(
        fuel_capacity: 100,
        fuel_level: 50,
        weight_capacity: 1000,
        pilot: pilot
      )
    end

    let!(:resource1) { Resource.create!(name: 'water', weight: 10) }
    let!(:resource2) { Resource.create!(name: 'food', weight: 20) }

    let!(:contract1) do
      Contract.create(
        description: 'Water contract',
        origin_planet: 'Andvari',
        destination_planet: 'Calas',
        value: 100,
        pilot: pilot,
        status: :completed,
        resource: resource1
      )
    end

    let!(:contract2) do
      Contract.create(
        description: 'Food contract',
        origin_planet: 'Calas',
        destination_planet: 'Andvari',
        value: 200,
        pilot: pilot,
        status: :completed,
        resource: resource2
      )
    end

    it 'returns the correct report data' do
      expected_report = {
        'Andvari' => {
          'sent' => { 'water' => 10 },
          'received' => { 'food' => 20 }
        },
        'Calas' => {
          'sent' => { 'food' => 20 },
          'received' => { 'water' => 10 }
        }
      }

      expect(Contract.generate_report).to eq(expected_report)
    end
  end
end
