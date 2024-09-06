# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ship, type: :model do
  describe 'associations' do
    it 'belongs to a pilot' do
      pilot = Pilot.create(
        pilot_certification: '12345',
        name: 'John Doe',
        age: 30,
        credits: 1000,
        location_planet: 'Earth'
      )
      ship = Ship.create(
        pilot: pilot,
        fuel_capacity: 100,
        fuel_level: 50,
        weight_capacity: 1000
      )
      expect(ship.pilot).to eq(pilot)
    end
  end

  describe 'validations' do
    it 'is not valid without a fuel capacity' do
      ship = Ship.new(fuel_level: 50, weight_capacity: 1000)
      expect(ship).to_not be_valid
    end

    it 'is not valid without a fuel level' do
      ship = Ship.new(fuel_capacity: 100, weight_capacity: 1000)
      expect(ship).to_not be_valid
    end

    it 'is not valid without a weight capacity' do
      ship = Ship.new(fuel_capacity: 100, fuel_level: 50)
      expect(ship).to_not be_valid
    end
  end

  describe "with a created ship" do
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
        weight_capacity: 100,
        pilot: pilot
      )
    end

    before do
      pilot.update!(ship: ship)
    end

    describe '#can_load?' do
      it 'returns true if the ship can load the weight' do
        expect(ship.can_load?(20)).to be true
      end

      it 'returns false if the ship cannot load the weight' do
        expect(ship.can_load?(200)).to be false
      end
    end

    describe '#enough_fuel?' do
      it 'returns true if the ship has enough fuel' do
        expect(ship.enough_fuel?(30)).to be true
      end

      it 'returns false if the ship does not have enough fuel' do
        expect(ship.enough_fuel?(60)).to be false
      end
    end

    describe '#consume_fuel' do
      it 'reduces the fuel level by the specified amount' do
        ship.consume_fuel(20)
        ship.reload

        expect(ship.fuel_level).to eq(30)
      end
    end
  end
end
