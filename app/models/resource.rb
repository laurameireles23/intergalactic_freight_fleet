# frozen_string_literal: true

class Resource < ApplicationRecord
  VALID_RESOURCE_NAME = ['minerals', 'water', 'food']

  has_many :contract

  validates :name, :weight, presence: true
  validates :name, inclusion: { in: VALID_RESOURCE_NAME }
end
