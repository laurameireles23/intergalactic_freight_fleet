# frozen_string_literal: true

class PilotsController < ApplicationController
  def create
    ActiveRecord::Base.transaction do
      pilot = Pilot.find_or_create_by(
        pilot_certification: pilots_params[:pilot_certification],
        name: pilots_params[:name],
        age: pilots_params[:age],
        credits: pilots_params[:credits],
        location_planet: pilots_params[:location_planet]
      )

      ship = pilot.create_ship(
        fuel_capacity: ship_params[:fuel_capacity],
        fuel_level: ship_params[:fuel_level],
        weight_capacity: ship_params[:weight_capacity]
      )

      if ship.persisted? && pilot.update(ship_id: ship.id)
        render json: pilot, status: :created
      else
        render json: { errors: pilot.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  private

  def pilots_params
    params.require(:pilot).permit(:pilot_certification, :name, :age, :credits, :location_planet)
  end

  def ship_params
    params.require(:ship).permit(:fuel_capacity, :fuel_level, :weight_capacity)
  end
end
