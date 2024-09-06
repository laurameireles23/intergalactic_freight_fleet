# frozen_string_literal: true

class ShipsController < ApplicationController
  def refuel
    ship = Ship.find(params[:id])
    units = params[:units].to_i

    if ship.refuel(units)
      render json: { message: "#{units} units of fuel added." }, status: :ok
    else
      render json: { errors: ship.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
