# frozen_string_literal: true

class CreateContract < ActiveRecord::Migration[7.1]
  def change
    create_table :contracts do |t|
      t.string :description
      t.string :origin_planet
      t.string :destination_planet
      t.integer :value

      t.timestamps
    end
  end
end
