class AddCatyToPacks < ActiveRecord::Migration
  def change
    add_column :packs, :caty, :string
  end
end
