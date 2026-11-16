class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :first_name
      t.string :last_name

      t.timestamps
    end

    add_index :users, "LOWER(email)",
              unique: true,
              name: "index_users_on_lower_email"
  end
end
