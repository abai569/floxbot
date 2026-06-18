class CreatePendingVerifications < ActiveRecord::Migration[8.0]
  def change
    create_table :pending_verifications do |t|
      t.bigint :group_id, null: false
      t.bigint :user_id, null: false
      t.string :user_name
      t.integer :message_id
      t.string :code
      t.integer :mode, default: 0
      t.datetime :expires_at, null: false
      t.timestamps
    end
    add_index :pending_verifications, [:group_id, :user_id], unique: true
    add_index :pending_verifications, :expires_at
  end
end
