class Api::RepliesController < ApplicationController
  
  
def show
  respond_to do |format|
    if Comment.exists?(params[:id])
      @comment = Comment.find(params[:id])
      @replies = Reply.where(comment_id: @comment.id)
      format.json { render json: @replies}
    else
      format.json { render json:{status:"error", code:404, message: "Comment with ID '" + params[:id].to_s + "' not found"}, status: :not_found}
    end
  end
end
  
end