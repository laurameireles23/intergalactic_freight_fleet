# frozen_string_literal: true

class Contract < ApplicationRecord
  enum status: { pending: 0, in_progress: 1, completed: 2, canceled: 3 }

  validates :status, inclusion: { in: statuses.keys }
  validates :description, :origin_planet, :destination_planet, :value, :status, presence: true

  belongs_to :resource
  belongs_to :pilot

  def can_accept_contract?(pilot)
    ship = pilot.ship

    return false unless pending? && ship.can_load?(resource.weight)

    ActiveRecord::Base.transaction do
      unless pilot.on_contract_origin_planet?(origin_planet)
        alternative_route = pilot.find_alternative_route(pilot.location_planet, origin_planet)

        unless alternative_route
          errors.add(:base, "No available route to travel from #{pilot.location_planet} to #{origin_planet}.")
          raise ActiveRecord::Rollback
        end

        fuel_needed_to_origin = alternative_route[:fuel_needed]

        ship.consume_fuel(fuel_needed_to_origin)
        pilot.update_location(origin_planet)
      end

      direct_fuel_needed = Pilot::FUEL_COSTS[origin_planet][destination_planet]
      if direct_fuel_needed != 'X'
        fuel_needed = direct_fuel_needed
      else
        alternative_route = pilot.find_alternative_route(origin_planet, destination_planet)

        unless alternative_route
          errors.add(:base, "No available route to travel from #{origin_planet} to #{destination_planet}.")
          raise ActiveRecord::Rollback
        end

        fuel_needed = alternative_route[:fuel_needed]
      end

      unless ship.enough_fuel?(fuel_needed)
        errors.add(:base, "Not enough fuel to travel from #{origin_planet} to #{destination_planet}.")
        raise ActiveRecord::Rollback
      end

      update!(status: :in_progress)
      resource.update!(fuel_needed: fuel_needed)

      true
    end
  end

  def complete_contract(pilot)
    ActiveRecord::Base.transaction do
      update!(status: :completed)
      pilot.ship.consume_fuel(resource.fuel_needed)
      pilot.update_location(destination_planet)
      pilot.pay_pilot(value)
    end
  end

  def self.generate_report
    planets_report = {}

    all.each do |contract|
      origin = contract.origin_planet
      destination = contract.destination_planet
      resource_name = contract.resource.name
      resource_weight = contract.resource.weight

      planets_report[origin] ||= { 'sent' => Hash.new(0), 'received' => Hash.new(0) }
      planets_report[destination] ||= { 'sent' => Hash.new(0), 'received' => Hash.new(0) }

      planets_report[origin]['sent'][resource_name] += resource_weight
      planets_report[destination]['received'][resource_name] += resource_weight
    end

    planets_report
  end
end
