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

  private

  def contract_params
    params.require(:contract).permit(
      :description, :origin_planet, :destination_planet, :value, :resource_id, :pilot_id, :status
    )
  end
end
