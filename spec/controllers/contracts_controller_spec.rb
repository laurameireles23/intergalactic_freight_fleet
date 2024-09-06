# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContractsController, type: :controller do
  describe 'POST #create' do
    let(:resource) do
      Resource.create(
        name: 'water',
        weight: 10
      )
    end

    let(:pilot) do
      Pilot.create(
        pilot_certification: '123456-x',
        name: 'John Doe',
        age: 35,
        credits: 100,
        location_planet: 'Earth'
      )
    end

    let(:valid_contract_params) do
      {
        contract: {
          description: 'Contract description',
          origin_planet: 'Earth',
          destination_planet: 'Mars',
          value: 1000,
          resource_id: resource.id,
          pilot_id: pilot.id,
          status: :pending
        }
      }
    end

    let(:invalid_contract_params) do
      {
        contract: {
          description: '',
          origin_planet: '',
          destination_planet: '',
          value: nil,
          resource_id: nil,
          pilot_id: nil,
          status: nil
        }
      }
    end

    context 'with valid params' do
      it 'creates a new contract' do
        expect {
          post :create, params: valid_contract_params
        }.to change(Contract, :count).by(1)
      end

      it 'returns a status of created' do
        post :create, params: valid_contract_params
        expect(response).to have_http_status(:created)
      end

      it 'returns the created contract as JSON' do
        post :create, params: valid_contract_params
        json_response = JSON.parse(response.body)
        expect(json_response['description']).to eq('Contract description')
        expect(json_response['status']).to eq('pending')
      end
    end

    context 'with invalid params' do
      it 'does not create a new contract' do
        expect {
          post :create, params: invalid_contract_params
        }.to_not change(Contract, :count)
      end

      it 'returns a status of unprocessable entity' do
        post :create, params: invalid_contract_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'POST #accept_contract_and_pay_pilot' do
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
        resource_id: resource.id,
        pilot_id: pilot.id,
        status: :pending,
        resource: resource
      )
    end

    context 'when the contract can be accepted' do
      before do
        pilot.update!(ship: ship)
      end

      it 'completes the contract and pays the pilot' do
        post :accept_contract_and_pay_pilot, params: { id: contract.id, pilot_id: pilot.id }
        contract.reload
        pilot.reload

        expect(response).to have_http_status(:ok)
        expect(contract.status).to eq('completed')
        expect(pilot.credits).to eq(100)
        expect(pilot.ship.fuel_level).to be < 50
      end
    end

    context 'when the contract cannot be accepted' do
      before do
        allow_any_instance_of(Contract).to receive(:can_accept_contract?).and_return(false)
      end

      it 'returns an error message' do
        post :accept_contract_and_pay_pilot, params: { id: contract.id, pilot_id: pilot.id }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('Contract to travel from')
      end
    end
  end
end
