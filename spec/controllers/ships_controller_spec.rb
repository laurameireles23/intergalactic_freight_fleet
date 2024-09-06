# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShipsController, type: :controller do
  let(:pilot) do
    Pilot.create(
      pilot_certification: '123456-x',
      name: 'John Doe',
      age: 35,
      credits: 100,
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

  describe 'POST #refuel' do
    context 'when the pilot has enough credits' do
      it 'refuels the ship and reduces the pilot\'s credits' do
        post :refuel, params: { id: ship.id, units: 5 }

        ship.reload
        pilot.reload

        expect(response).to have_http_status(:ok)
        expect(ship.fuel_level).to eq(55)
        expect(pilot.credits).to eq(65)
        expect(JSON.parse(response.body)['message']).to eq('5 units of fuel added.')
      end
    end

    context 'when the pilot does not have enough credits' do
      before { pilot.update!(credits: 10) }

      it 'does not refuel the ship and returns an error message' do
        post :refuel, params: { id: ship.id, units: 5 }

        ship.reload
        pilot.reload

        expect(response).to have_http_status(:unprocessable_entity)
        expect(ship.fuel_level).to eq(50)
        expect(pilot.credits).to eq(10)
        expect(JSON.parse(response.body)['errors']).to include('Not enough credits to refuel.')
      end
    end
  end
end
