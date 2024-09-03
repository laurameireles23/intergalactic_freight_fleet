# frozen_string_literal: true

class CreateShip < ActiveRecord::Migration[7.1]
  def change
    create_table :ships do |t|
      t.integer :fuel_capacity
      t.integer :fuel_level
      t.integer :weight_capacity

      t.timestamps
    end
  end
end
