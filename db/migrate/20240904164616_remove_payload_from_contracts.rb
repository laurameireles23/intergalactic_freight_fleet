class RemovePayloadFromContracts < ActiveRecord::Migration[7.1]
  def change
    remove_column :contracts, :payload_id
  end
end
