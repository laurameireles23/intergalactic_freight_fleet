# frozen_string_literal: true

class AddPilotAndStatusToContract < ActiveRecord::Migration[7.1]
  def change
    add_reference :contracts, :pilot, foreign_key: { to_table: :pilots }

    add_column :contracts, :status, :string
  end
end
