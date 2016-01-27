class AddConnectionTypeAndPackTypeToPacks < ActiveRecord::Migration
  def change
    add_column :packs, :connection_type, :boolean
    add_column :packs, :pack_type, :integer
  end
end
