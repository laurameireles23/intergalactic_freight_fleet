# frozen_string_literal: true

class Pilot < ApplicationRecord
  has_one :ship, dependent: :destroy
  has_many :contracts
  
  accepts_nested_attributes_for :ship

  validates :pilot_certification, :name, :age, :credits, :location_planet, presence: true
end
