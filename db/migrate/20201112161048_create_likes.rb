class CreateLikes < ActiveRecord::Migration[6.0]
  def change
    create_table :likes do |t|
      t.integer :contribution_id
      t.integer :comment_id
      t.integer :reply_id
      t.integer :user_id
    end
  end
end
