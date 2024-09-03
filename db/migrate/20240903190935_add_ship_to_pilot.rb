# frozen_string_literal: true

class AddShipToPilot < ActiveRecord::Migration[7.1]
  def change
    add_reference :pilots, :ship, foreign_key: { to_table: :ships }
  end
end
