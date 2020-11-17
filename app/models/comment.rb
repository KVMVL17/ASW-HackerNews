class Comment < ApplicationRecord
  belongs_to  :user, optional: true
  belongs_to  :contribution, optional: true
  has_many :replies
end
