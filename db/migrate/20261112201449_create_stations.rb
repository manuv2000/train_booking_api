
class CreateStations < ActiveRecord::Migration[8.1]
  def change
    create_table :stations do |t|
      t.string :external_id, null: false
      t.string :name, null: false

      t.decimal :latitude, precision: 12, scale: 8
      t.decimal :longitude, precision: 12, scale: 8

      t.timestamps
    end

    add_index :stations, :external_id, unique: true
  end
end
