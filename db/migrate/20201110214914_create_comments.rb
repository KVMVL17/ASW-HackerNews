class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.string :creator
      t.string :content
      t.integer :contribution_id
      
      t.timestamps
    end
  end
end
