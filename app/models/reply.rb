class Reply < ApplicationRecord
  belongs_to  :comment, optional: true
  has_many :replies, dependent: :destroy
  
  def findContribution(id)
    reply = Reply.find(id)
    while !reply.reply_id.nil?
      reply = Reply.find(reply.reply_id)
    end
    return reply.comment.contribution_id
  end
end
