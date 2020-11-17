class Reply < ApplicationRecord
  belongs_to  :comment, optional: true
  has_many :replies, dependent: :destroy
  acts_as_nested_tree
end
