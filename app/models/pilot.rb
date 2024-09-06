# frozen_string_literal: true

class Pilot < ApplicationRecord
  has_one :ship, dependent: :destroy
  has_many :contracts

  accepts_nested_attributes_for :ship

  validates :pilot_certification, :name, :age, :credits, :location_planet, presence: true

  FUEL_COSTS = {
    'Andvari' => { 'Deméter' => 'X', 'Água' => 13, 'Calas' => 23 },
    'Deméter' => { 'Andvari' => 'X', 'Água' => 22, 'Calas' => 25 },
    'Água' => { 'Andvari' => 'X', 'Deméter' => 30, 'Calas' => 12 },
    'Calas' => { 'Andvari' => 20, 'Deméter' => 25, 'Água' => 15 }
  }

  def travel_to(destination_planet)
    current_planet = location_planet
    fuel_needed = FUEL_COSTS[current_planet][destination_planet]

    if fuel_needed == 'X'
      errors.add(:base, "Travel from #{current_planet} to #{destination_planet} is not possible due to obstacles.")

      false
    elsif ship.fuel_level < fuel_needed
      errors.add(:base, "Not enough fuel to travel from #{current_planet} to #{destination_planet}.")

      false
    else
      ActiveRecord::Base.transaction do
        ship.update!(fuel_level: ship.fuel_level - fuel_needed)
        update!(location_planet: destination_planet)
      end

      true
    end
  end

  def find_alternative_route(from_planet, to_planet)
    FUEL_COSTS[from_planet].each do |intermediate_planet, fuel_needed_to_intermediate|
      next if fuel_needed_to_intermediate == 'X'

      fuel_needed_from_intermediate = FUEL_COSTS[intermediate_planet][to_planet]

      next if fuel_needed_from_intermediate == 'X'

      total_fuel_needed = fuel_needed_to_intermediate + fuel_needed_from_intermediate

      return {
        path: [from_planet, intermediate_planet, to_planet],
        fuel_needed: total_fuel_needed
      }
    end

    nil
  end

  def on_contract_origin_planet?(destination)
    location_planet == destination
  end

  def update_location(new_planet)
    update!(location_planet: new_planet)
  end

  def pay_pilot(value)
    update!(credits: credits + value)
  end
end
