# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PilotsController, type: :controller do
  describe 'POST #create' do
    let(:pilot_params) do
      {
        pilot: {
          pilot_certification: '12345',
          name: 'John Doe',
          age: 30,
          credits: 1000,
          location_planet: 'Earth'
        },
        ship: {
          fuel_capacity: 100,
          fuel_level: 50,
          weight_capacity: 1000
        }
      }
    end

    context 'with valid params' do
      it 'creates a new pilot and ship' do
        expect {
          post :create, params: pilot_params
        }.to change(Pilot, :count).by(1).and change(Ship, :count).by(1)
      end

      it 'returns a status of created' do
        post :create, params: pilot_params
        expect(response).to have_http_status(:created)
      end

      it 'returns the created pilot as JSON' do
        post :create, params: pilot_params
        json_response = JSON.parse(response.body)
        expect(json_response['name']).to eq('John Doe')
        expect(json_response['ship_id']).to be_present
      end
    end
  end
end
