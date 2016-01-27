class CreatePrlinks < ActiveRecord::Migration
  def change
    create_table :prlinks do |t|
      t.integer :region_id
      t.integer :operator_id
      t.string :link1
      t.string :link2
      t.string :link3
      t.string :link4

      t.timestamps null: false
    end
  end
end
