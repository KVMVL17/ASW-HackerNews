class CreateComment < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.string :content
      t.string :creator
      t.string :contribution_id
      
      t.timestamps
    end
  end
end
