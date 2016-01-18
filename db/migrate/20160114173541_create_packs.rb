class CreatePacks < ActiveRecord::Migration
  def change
    create_table :packs do |t|
      t.integer :region_id
      t.integer :operator_id
      t.string :price
      t.string :offer
      t.string :validity
      t.text :description
      t.text :tag

      t.timestamps null: false
    end
  end
end
