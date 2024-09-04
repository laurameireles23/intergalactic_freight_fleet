# frozen_string_literal: true

class Ship < ApplicationRecord
  belongs_to :pilot

  validates :fuel_capacity, :fuel_level, :weight_capacity, presence: true
end
