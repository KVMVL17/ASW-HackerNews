require 'uri'

class Contribution < ApplicationRecord
  validates_presence_of :title
  validates_presence_of :url_and_text
  validates :url_is, presence: true
  belongs_to :user, optional: true
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  
  def text_is_blank?
    text.blank?
  end
  
  def url_and_text
    !(url.blank? && text.blank?)
  end
  
  def checkIfMine(username)
    username == user_id
  end
  
  def numberOfComments(c)
    count = 0
    c.each do |r|
      if r.replies.any?
        auxSuma = numberOfComments(r.replies)
        count += auxSuma
      end
      count += 1
    end
    return count
  end
  
  def url_is
    url =~ /\A#{URI::regexp(['http', 'https'])}\z/ || url.blank?
  end

end