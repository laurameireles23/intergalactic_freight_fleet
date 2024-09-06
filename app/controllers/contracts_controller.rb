# frozen_string_literal: true

class ContractsController < ApplicationController
  def create
    contract = Contract.new(contract_params)

    if contract.save
      render json: contract, status: :created
    else
      render json: { errors: contract.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def accept_contract_and_pay_pilot
    contract = Contract.find(params[:id])
    pilot = Pilot.find(params[:pilot_id])

    if contract.can_accept_contract?(pilot)
      contract.complete_contract(pilot)

      render json: { message: "Contract accepted and completed by #{pilot.name}!" }, status: :ok
    else
      render json: {
        errors: "Contract to travel from #{contract.origin_planet} to #{contract.destination_planet} is not possible"
      }, status: :unprocessable_entity
    end
  end

  private

  def contract_params
    params.require(:contract).permit(
      :description, :origin_planet, :destination_planet, :value, :resource_id, :pilot_id, :status
    )
  end
end
