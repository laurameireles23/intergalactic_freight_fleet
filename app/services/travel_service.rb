# frozen_string_literal: true

class TravelService
  def initialize(pilot, destination_planet)
    @pilot = pilot
    @destination_planet = destination_planet
  end

  def call
    fuel_needed = Pilot::FUEL_COSTS[@pilot.location_planet][@destination_planet]

    if fuel_needed == 'X'
      @pilot.errors.add(
        :base,
        "Travel from #{@pilot.location_planet} to #{@destination_planet} is not possible due to obstacles."
      )

      false
    elsif @pilot.ship.fuel_level < fuel_needed
      @pilot.errors.add(:base, "Not enough fuel to travel from #{@pilot.location_planet} to #{@destination_planet}.")

      false
    else
      ActiveRecord::Base.transaction do
        @pilot.ship.update!(fuel_level: @pilot.ship.fuel_level - fuel_needed)
        @pilot.update!(location_planet: @destination_planet)
      end

      true
    end
  end
end
