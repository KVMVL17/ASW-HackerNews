class CreateReplies < ActiveRecord::Migration[6.0]
  def change
    create_table :replies do |t|
      t.string :content
      t.integer :user_id
      t.integer :comment_id
      t.integer :reply_id
      t.integer :points, default:0

      t.timestamps
    end
  end
end
