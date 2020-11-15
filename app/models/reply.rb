class Reply < ApplicationRecord
  belongs_to  :comment, optional: true
  has_many :replies, dependent: :destroy
end
