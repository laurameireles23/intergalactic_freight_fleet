# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Integration Tests", type: :request do
  let!(:pilot) do
    Pilot.create!(
      pilot_certification: '123456-x',
      name: 'Han Solo',
      age: 35,
      credits: 1000,
      location_planet: 'Calas'
    )
  end

  let(:ship) { Ship.create!(fuel_capacity: 100, fuel_level: 100, weight_capacity: 500, pilot: pilot) }

  let!(:resource) { Resource.create!(name: 'minerals', weight: 5) }

  it 'should create a pilot, ship, contract, travel, accept contract, refuel, and generate report' do
    # 1. Creating a pilot and a ship
    expect(pilot.name).to eq('Han Solo')
    expect(ship.fuel_level).to eq(100)
    expect(pilot.ship).to eq(ship)

    # 2. Creating a new contract for a resource
    contract_params = {
      description: 'Water from Calas to Andvari',
      origin_planet: 'Calas',
      destination_planet: 'Andvari',
      value: 500,
      pilot_id: pilot.id,
      resource_id: resource.id,
      status: 'pending'
    }
    post '/contracts', params: { contract: contract_params }
    expect(response).to have_http_status(:created)

    contract = Contract.last
    resource = contract.resource
    expect(contract.origin_planet).to eq('Calas')
    expect(contract.destination_planet).to eq('Andvari')
    expect(resource.name).to eq('minerals')

    # 3. Pilot travels between planets
    post "/pilots/#{pilot.id}/travel", params: { destination_planet: 'Andvari' }
    pilot.reload
    ship.reload
    expect(pilot.location_planet).to eq('Andvari')
    expect(ship.fuel_level).to eq(80)

    # 4. Pilot accepts a contract
    post "/contracts/#{contract.id}/accept_and_pay", params: { pilot_id: pilot.id }
    contract.reload
    resource.reload
    expect(resource.fuel_needed).to eq(20)

    # 5. Finalize the contract and pay the pilot
    contract.complete_contract(pilot)
    pilot.reload
    ship.reload
    expect(contract.status).to eq('completed')
    expect(pilot.credits).to eq(1500)
    expect(ship.fuel_level).to eq(15)

    # 6. Pilot refuels the ship
    post "/ships/#{ship.id}/refuel", params: { units: 10 }
    ship.reload
    expect(ship.fuel_level).to eq(25)

    # 7. Report generation
    get '/contracts/report'
    expect(response).to have_http_status(:ok)

    report_data = JSON.parse(response.body)

    expect(report_data['Calas']['sent']['minerals']).to eq(5)
    expect(report_data['Andvari']['received']['minerals']).to eq(5)
  end
end
