class CreateKeywordReplies < ActiveRecord::Migration[8.0]
  def change
    create_table :keyword_replies do |t|
      t.bigint :group_id, null: false
      t.string :keyword, null: false
      t.integer :reply_type, default: 0
      t.text :reply_content
      t.text :reply_text
      t.boolean :is_regex, default: false
      t.boolean :is_exact, default: false
      t.timestamps
    end
    add_index :keyword_replies, :group_id
    add_index :keyword_replies, [:group_id, :keyword], unique: true
  end
end
