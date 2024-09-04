# frozen_string_literal: true

class Contract < ApplicationRecord
  enum status: { pending: 0, in_progress: 1, completed: 2, canceled: 3 }

  validates :status, inclusion: { in: statuses.keys }
  validates :description, :origin_planet, :destination_planet, :value, :status, presence: true

  belongs_to :resource
  belongs_to :pilot
end
