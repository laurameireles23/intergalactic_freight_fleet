# frozen_string_literal: true

class Ship < ApplicationRecord
  belongs_to :pilot

  validates :fuel_capacity, :fuel_level, :weight_capacity, presence: true

  def can_load?(load_weight)
    weight_capacity >= load_weight
  end

  def enough_fuel?(fuel_needed)
    fuel_level >= fuel_needed
  end

  def consume_fuel(fuel_used)
    update!(fuel_level: fuel_level - fuel_used)
  end
end
