# frozen_string_literal: true

class CreatePilot < ActiveRecord::Migration[7.1]
  def change
    create_table :pilots do |t|
      t.string :pilot_certification
      t.string :name
      t.integer :age
      t.integer :credits
      t.string :location_planet

      t.timestamps
    end
  end
end
