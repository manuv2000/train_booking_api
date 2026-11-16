class CreateStationPreferences < ActiveRecord::Migration[8.1]
  def change
    create_table :station_preferences do |t|
      t.references :user, null: false, foreign_key: true
      t.references :station, null: false, foreign_key: true

      t.integer :selection_count, null: false, default: 0

      t.timestamps
    end

    add_index :station_preferences,
              [ :user_id, :station_id ],
              unique: true
  end
end
