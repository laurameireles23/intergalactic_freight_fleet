# frozen_string_literal: true

class AddPilotToShip < ActiveRecord::Migration[7.1]
  def change
    add_reference :ships, :pilot, foreign_key: { to_table: :pilots }
  end
end
