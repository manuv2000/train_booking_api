class AddPublicIdToStations < ActiveRecord::Migration[8.1]
  def change
    add_column :stations, :public_id, :uuid,
               default: -> { "gen_random_uuid()" },
               null: false

    add_index :stations, :public_id, unique: true
  end
end
