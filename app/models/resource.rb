# frozen_string_literal: true

class Resource < ApplicationRecord
  has_many :contract

  validates :name, :weight, presence: true
end
