class AddDateCreatedToRentals < ActiveRecord::Migration[5.2]
  def change
    add_column :rentals, :date_created, :date
  end
end
