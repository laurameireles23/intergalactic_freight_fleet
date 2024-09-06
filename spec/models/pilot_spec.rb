# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pilot, type: :model do
  describe 'associations' do
    it 'has one ship with dependent destroy' do
      pilot = Pilot.create(
        pilot_certification: '12345',
        name: 'John Doe',
        age: 30,
        credits: 1000,
        location_planet: 'Earth'
      )
      pilot.create_ship(fuel_capacity: 100, fuel_level: 50, weight_capacity: 1000)
      expect { pilot.destroy }.to change { Ship.count }.by(-1)
    end

    it 'accepts nested attributes for ship' do
      pilot = Pilot.new(
        pilot_certification: '12345',
        name: 'John Doe',
        age: 30,
        credits: 1000,
        location_planet: 'Earth',
        ship_attributes: { fuel_capacity: 100, fuel_level: 50, weight_capacity: 1000 }
      )
      expect(pilot.ship).to be_present
    end
  end

  describe 'validations' do
    it 'is not valid without a pilot certification' do
      pilot = Pilot.new(name: 'John Doe', age: 30, credits: 1000, location_planet: 'Earth')
      expect(pilot).to_not be_valid
    end

    it 'is not valid without a name' do
      pilot = Pilot.new(pilot_certification: '12345', age: 30, credits: 1000, location_planet: 'Earth')
      expect(pilot).to_not be_valid
    end

    it 'is not valid without an age' do
      pilot = Pilot.new(pilot_certification: '12345', name: 'John Doe', credits: 1000, location_planet: 'Earth')
      expect(pilot).to_not be_valid
    end

    it 'is not valid without credits' do
      pilot = Pilot.new(pilot_certification: '12345', name: 'John Doe', age: 30, location_planet: 'Earth')
      expect(pilot).to_not be_valid
    end

    it 'is not valid without a location planet' do
      pilot = Pilot.new(pilot_certification: '12345', name: 'John Doe', age: 30, credits: 1000)
      expect(pilot).to_not be_valid
    end
  end

  describe '#travel_to' do
    let(:pilot) do
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

    context 'when travel is blocked due to obstacles' do
      it 'adds an error and returns false' do
        expect(pilot.travel_to('Deméter')).to be false
        expect(pilot.errors[:base]).to include('Travel from Andvari to Deméter is not possible due to obstacles.')
      end
    end

    context 'when there is not enough fuel' do
      before { ship.update(fuel_level: 10) }

      it 'adds an error and returns false' do
        expect(pilot.travel_to('Calas')).to be false
        expect(pilot.errors[:base]).to include('Not enough fuel to travel from Andvari to Calas.')
      end
    end

    context 'when travel is successful' do
      it 'updates the ship’s fuel and the pilot’s location' do
        expect(pilot.travel_to('Calas')).to be true
        pilot.reload
        expect(pilot.location_planet).to eq('Calas')
        expect(pilot.ship.fuel_level).to eq(27)
      end
    end
  end

  describe '#find_alternative_route' do
    let(:pilot) do
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

    before do
      pilot.update!(ship: ship)
    end

    it 'returns a valid alternative route' do
      route = pilot.find_alternative_route('Andvari', 'Calas')

      expect(route).not_to be_nil
      expect(route[:path]).to eq(['Andvari', 'Água', 'Calas'])
    end
  end

  describe '#on_contract_origin_planet?' do
    let(:pilot) do
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

    before do
      pilot.update!(ship: ship)
    end

    it 'returns true if the pilot is on the contract origin planet' do
      expect(pilot.on_contract_origin_planet?('Andvari')).to be true
    end

    it 'returns false if the pilot is not on the contract origin planet' do
      expect(pilot.on_contract_origin_planet?('Calas')).to be false
    end
  end

  describe '#pay_pilot' do
    let(:pilot) do
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

    before do
      pilot.update!(ship: ship)
    end

    it 'adds credits to the pilot' do
      pilot.pay_pilot(100)
      pilot.reload

      expect(pilot.credits).to eq(200)
    end
  end
end
