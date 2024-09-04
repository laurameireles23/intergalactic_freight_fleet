# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ResourcesController, type: :controller do
  describe 'POST #create' do
    let(:valid_resource_params) do
      {
        resource: {
          name: 'Resource name',
          weight: 10
        }
      }
    end

    let(:invalid_resource_params) do
      {
        resource: {
          name: '',
          weight: nil
        }
      }
    end

    context 'with valid params' do
      it 'creates a new resource' do
        expect {
          post :create, params: valid_resource_params
        }.to change(Resource, :count).by(1)
      end

      it 'returns a status of created' do
        post :create, params: valid_resource_params
        expect(response).to have_http_status(:created)
      end

      it 'returns the created resource as JSON' do
        post :create, params: valid_resource_params
        json_response = JSON.parse(response.body)
        expect(json_response['name']).to eq('Resource name')
        expect(json_response['weight']).to eq(10)
      end
    end

    context 'with invalid params' do
      it 'does not create a new resource' do
        expect {
          post :create, params: invalid_resource_params
        }.to_not change(Resource, :count)
      end

      it 'returns a status of unprocessable entity' do
        post :create, params: invalid_resource_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns errors as JSON' do
        post :create, params: invalid_resource_params
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Name can't be blank")
        expect(json_response['errors']).to include("Weight can't be blank")
      end
    end
  end
end
