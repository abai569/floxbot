class CreateGroupConfigs < ActiveRecord::Migration[8.0]
  def change
    create_table :group_configs do |t|
      t.bigint :group_id, null: false
      t.string :group_name
      t.integer :verification_mode, default: 0
      t.integer :verification_timeout, default: 60
      t.text :welcome_text
      t.string :welcome_photo_id
      t.string :welcome_video_id
      t.text :welcome_buttons_json
      t.boolean :del_join, default: false
      t.boolean :del_leave, default: false
      t.boolean :del_forward, default: false
      t.boolean :del_keyword, default: false
      t.boolean :del_service, default: false
      t.timestamps
    end
    add_index :group_configs, :group_id, unique: true
  end
end
