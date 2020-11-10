class Contribution < ApplicationRecord
  validates_presence_of :title

  def text_is_blank?
    text.blank?
  end

end