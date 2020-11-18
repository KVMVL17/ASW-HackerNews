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
    username == creator
  end
  
  def numberOfComments(c, suma)
    c.each do |r|
      if r.replies.any?
        suma += numberOfComments(r.replies, suma)
      end
      suma += 1
    end
    return suma
  end
  
  def url_is
    url =~ /\A#{URI::regexp(['http', 'https'])}\z/ || url.blank?
  end

end