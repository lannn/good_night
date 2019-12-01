class CreateSleepClocks < ActiveRecord::Migration[6.0]
  def change
    create_table :sleep_clocks do |t|
      t.timestamps
      t.references :user, null: false, foreign_key: true
      t.datetime :bedtime
      t.datetime :wakeup
    end
  end
end
