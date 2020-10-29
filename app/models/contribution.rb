class Contribution < ApplicationRecord
  validates_presence_of :title
  validates_presence_of :url_or_text

  def url_or_text
    (url.blank? ^ text.blank?)
  end
  
  def text_is_blank?
    text.blank?
  end

end