# frozen_string_literal: true

class AddPayloadToContract < ActiveRecord::Migration[7.1]
  def change
    add_reference :contracts, :payload, foreign_key: { to_table: :resources }
  end
end
