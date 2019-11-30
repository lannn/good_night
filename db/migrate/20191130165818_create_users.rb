class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.timestamps
      t.string :name, null: false
      t.string :auth_token, null: false
    end
    add_index :users, :auth_token, unique: true
  end
end
