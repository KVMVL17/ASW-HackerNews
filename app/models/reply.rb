class Reply < ApplicationRecord
  validates_presence_of :content
  belongs_to  :comment, optional: true
  has_many :replies, dependent: :destroy
  has_many :likes, dependent: :destroy

  
  def findContribution(id)
    reply = Reply.find(id)
    while !reply.reply_id.nil?
      reply = Reply.find(reply.reply_id)
    end
    return reply.comment.contribution_id
  end
  
  def checkIfMine(username)
    username == creator
  end
end
