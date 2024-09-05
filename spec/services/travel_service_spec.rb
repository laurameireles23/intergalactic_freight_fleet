# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TravelService, type: :service do
  describe '#call' do
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
    let(:service) { TravelService.new(pilot, destination_planet) }

    context 'when travel is blocked by obstacles' do
      let(:destination_planet) { 'Deméter' }

      it 'adds an error and returns false' do
        expect(service.call).to be false
        expect(pilot.errors[:base]).to include('Travel from Andvari to Deméter is not possible due to obstacles.')
      end
    end

    context 'when not enough fuel' do
      let(:destination_planet) { 'Calas' }

      before { ship.update(fuel_level: 10) }

      it 'adds an error and returns false' do
        expect(service.call).to be false
        expect(pilot.errors[:base]).to include('Not enough fuel to travel from Andvari to Calas.')
      end
    end

    context 'when travel is successful' do
      let(:destination_planet) { 'Calas' }

      it 'updates the pilot’s location and reduces ship fuel' do
        expect(service.call).to be true
        pilot.reload
        expect(pilot.location_planet).to eq('Calas')
        expect(pilot.ship.fuel_level).to eq(27)
      end
    end
  end
end
