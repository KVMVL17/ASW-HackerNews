class CreateReplies < ActiveRecord::Migration[6.0]
  def change
    create_table :replies do |t|
      t.string :content
      t.string :creator
      t.string :comment_id
      t.string :reply_id

      t.timestamps
    end
  end
end
