class CreateFollowings < ActiveRecord::Migration[6.0]
  def change
    create_table :followings do |t|
      t.timestamps
      t.integer :user_id
      t.integer :follower_id
    end

    add_index :followings, :user_id
    add_index :followings, :follower_id
    add_index :followings, [:user_id, :follower_id], unique: true
  end
end
