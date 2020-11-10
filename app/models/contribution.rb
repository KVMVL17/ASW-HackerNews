class Contribution < ApplicationRecord
  validates_presence_of :title
  belongs_to :user, optional: true
  has_many :comments
  
  def text_is_blank?
    text.blank?
  end
  
  def checkIfMine(username)
    username == creator
  end

end