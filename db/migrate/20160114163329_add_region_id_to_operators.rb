class AddRegionIdToOperators < ActiveRecord::Migration
  def change
    add_column :operators, :region_id, :integer
  end
end
