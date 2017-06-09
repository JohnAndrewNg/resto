class RenameAdresssInRestaurantsToAddress < ActiveRecord::Migration[5.0]
  def change
    rename_column :restaurants, :addresss, :address
  end
end
