# frozen_string_literal: true

class Ship < ApplicationRecord
  belongs_to :pilot

  validates :fuel_capacity, :fuel_level, :weight_capacity, presence: true

  FUEL_COST_PER_UNIT = 7

  def can_load?(load_weight)
    weight_capacity >= load_weight
  end

  def enough_fuel?(fuel_needed)
    fuel_level >= fuel_needed
  end

  def consume_fuel(fuel_used)
    update!(fuel_level: fuel_level - fuel_used)
  end

  def refuel(units)
    cost = units * FUEL_COST_PER_UNIT

    if pilot.credits >= cost
      ActiveRecord::Base.transaction do
        pilot.update!(credits: pilot.credits - cost)
        update!(fuel_level: fuel_level + units)
      end
    else
      errors.add(:base, 'Not enough credits to refuel.')
      false
    end
  end
end
