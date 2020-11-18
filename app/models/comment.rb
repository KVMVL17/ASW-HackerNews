class Comment < ApplicationRecord
  belongs_to  :user, optional: true
  belongs_to  :contribution, optional: true
  has_many :replies
    
  def checkIfMine(username)
    username == creator
  end
end

