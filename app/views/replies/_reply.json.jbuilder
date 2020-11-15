json.extract! reply, :id, :content, :creator, :comment_id, :parent_id, :created_at, :updated_at
json.url reply_url(reply, format: :json)
