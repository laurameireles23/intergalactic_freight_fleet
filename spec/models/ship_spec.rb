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
end
