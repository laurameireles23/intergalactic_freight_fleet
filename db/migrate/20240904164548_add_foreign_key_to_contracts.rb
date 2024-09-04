class AddForeignKeyToContracts < ActiveRecord::Migration[7.1]
  def change
    add_reference :contracts, :resource, foreign_key: { to_table: :resources }
  end
end
