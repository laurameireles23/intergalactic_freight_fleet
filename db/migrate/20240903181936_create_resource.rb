# frozen_string_literal: true

class CreateResource < ActiveRecord::Migration[7.1]
  def change
    create_table :resources do |t|
      t.string :name
      t.integer :weight

      t.timestamps
    end
  end
end
