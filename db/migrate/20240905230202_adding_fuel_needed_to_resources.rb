class AddingFuelNeededToResources < ActiveRecord::Migration[7.1]
  def change
    add_column :resources, :fuel_needed, :integer
  end
end
