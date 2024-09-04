# frozen_string_literal: true

class ChangeStatusToIntegerInContracts < ActiveRecord::Migration[7.1]
  def change
    remove_column :contracts, :status

    add_column :contracts, :status, :integer, default: 0
  end
end
