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
end
