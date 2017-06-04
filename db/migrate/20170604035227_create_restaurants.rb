class CreateRestaurants < ActiveRecord::Migration[5.0]
  def change
    create_table :restaurants do |t|
      t.string :placeid
      t.string :name
      t.float :latitude
      t.float :longitude
      t.string :addresss
      t.integer :zipcode
      t.string :phone_number
      t.string :url
      t.integer :price_level
      t.float :rating
      t.text :opening_hours
      t.string :photo_url

      t.timestamps

    end
  end
end
