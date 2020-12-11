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
  
  def show_replies
    respond_to do |format|
      if Reply.exists?(params[:id])
        @reply = Reply.find(params[:id])
        @replies = Reply.where(reply_id: @reply.id)
        format.json { render json: @replies}
      else
        format.json { render json:{status:"error", code:404, message: "Reply with ID '" + params[:id].to_s + "' not found"}, status: :not_found}
      end
    end
  end
  
  def showReply
    respond_to do |format|
      if Reply.exists?(params[:id])
        @reply = Reply.find(params[:id])
        format.json { render json: @reply, status: :ok}
      else
        format.json { render json:{status:"error", code:404, message: "Reply with ID '" + params[:id] + "' not found"}, status: :not_found}
      end
    end
  end
  
  def create_recursive
    respond_to do |format|
      if request.headers['X-API-KEY'].present?
        @user = User.find_by_apiKey(request.headers['X-API-KEY'].to_s)
        if @user.nil?
          format.json { render json: { status: "error", code: 403, message: "Your api key " + request.headers['X-API-KEY'].to_s + " is not valid"}, status: :forbidden }
        else
          
          if !Reply.exists?(params[:id])
            format.json { render json: { status: "error", code: 404, message: "Reply with ID: " + params[:id] + " not found"}, status: :not_found }
          else
            @reply = Reply.new
            @reply.content = params[:content]
            @reply.user_id = @user.id
            @reply.reply_id = params[:id]
              
            if @reply.save
              format.json { render json: @reply, status: :created }
            else
              format.json { render json: { status: "error", code: 400, message: "Content can't be blank" }, status: :bad_request }
            end
          end
          format.json { render json: { status: "error", code: 401, message: "You provided no api key"}, status: :unprocessable_entity }
        end
      else
        format.json { render json:{status: "error", code: 401, message: "You provided no api key"}, status: :unauthorized}
      end
    end
  end
    

  def create
    respond_to do |format|
      if request.headers['X-API-KEY'].present?
        @user = User.find_by_apiKey(request.headers['X-API-KEY'].to_s)
        if @user.nil?
          format.json { render json: { status: "error", code: 403, message: "Your api key " + request.headers['X-API-KEY'].to_s + " is not valid"}, status: :forbidden }
        else
          
          if !Comment.exists?(params[:id])
            format.json { render json: { status: "error", code: 404, message: "Comment with ID: " + params[:id] + " not found"}, status: :not_found }
          else
            @reply = Reply.new
            @reply.content = params[:content]
            @reply.user_id = @user.id
            @reply.comment_id = params[:id]
              
            if @reply.save
              format.json { render json: @reply, status: :created }
            else
              format.json { render json: { status: "error", code: 400, message: "Content can't be blank" }, status: :bad_request }
            end
          end
          format.json { render json: { status: "error", code: 401, message: "You provided no api key"}, status: :unprocessable_entity }
        end
      else
        format.json { render json:{status: "error", code: 401, message: "You provided no api key"}, status: :unauthorized}
      end
    end
  end
  
  def update
    respond_to do |format|
      if request.headers['X-API-KEY'].present?
        @user = User.find_by_apiKey(request.headers['X-API-KEY'].to_s)
        if @user.nil?
          format.json { render json: { status: "error", code: 403, message: "Your api key " + request.headers['X-API-KEY'].to_s + " is not valid"}, status: :forbidden }
        else
          if !Reply.exists?(params[:id])
            format.json { render json: { status: "error", code: 404, message: "Reply with ID: " + params[:id] + " not found"}, status: :not_found }
          else
            @reply = Reply.find(params[:id])
            if @reply.user_id == @user.id
              @reply.content = params[:content]
              if @reply.save
                format.json { render json: @reply, status: :ok }
              else
                format.json { render json: { status: "error", code: 400, message: "Content can't be blank" }, status: :bad_request }
              end
            else
              format.json { render json:{status: "error", code:403, message: "This reply does not belong to you"}, status: :forbidden}
            end
          end
        end
      else
        format.json { render json:{status: "error", code: 401, message: "You provided no api key"}, status: :unauthorized}
      end
    end
  end
  
  def destroy
    respond_to do |format|
      if request.headers['X-API-KEY'].present?
        @user = User.find_by_apiKey(request.headers['X-API-KEY'].to_s)
        if @user.nil?
          format.json { render json:{status: "error", code:403, message: "Your api key " + request.headers['X-API-KEY'].to_s + " is not valid"}, status: :forbidden}
        else
          if Reply.exists?(params[:id])
            @reply = Reply.find(params[:id])
            if @reply.user_id == @user.id
              @reply.destroy
              format.json { render json: { status: "no content", code: 204, message: "Reply deleted" }, status: :no_content }
            else
              format.json { render json:{status: "error", code:403, message: "This reply does not belong to you"}, status: :forbidden}
            end
          else
            format.json { render json: { status: "error", code: 404, message: "Reply with ID: " + params[:id] + " not found" }, status: :not_found }
          end
        end
      else
        format.json { render json:{status:"error", code:401, message: "You provided no api key"}, status: :unauthorized}
      end
    end
  end
  
  def like
    respond_to do |format|
      if request.headers['X-API-KEY'].present?
        @token = request.headers['X-API-KEY'].to_s
        @user  = User.find_by_apiKey(@token)
        if !@user.nil?
          if Reply.exists?(params[:id])
            @reply = Reply.find(params[:id])
            @like = Like.where(reply_id: @reply.id, user_id: @user.id).first
            if @like.nil?
              @like = Like.new
              @like.reply_id= params[:id]
              @like.user_id = @user.id
              @reply.points += 1
              @reply.save
              @like.save
              @user.karma +=1
              @user.save
              format.json { render json: @reply, status: :created}
            else
              format.json { render json:{status:"error", code:404, message: "Reply already voted"}, status: :not_found}
            end
          else
            format.json { render json:{status:"error", code:404, message: "Reply with id " + params[:id] + " not found"}, status: :not_found}
          end
        else
          format.json { render json:{status: "error", code:403, message: "Your api key " + request.headers['X-API-KEY'].to_s + " is not valid"}, status: :forbidden}
        end
      else
        format.json { render json:{status:"error", code:401, message: "You provided no api key"}, status: :unauthorized}
      end
    end
  end
  
  
  def dislike
    respond_to do |format|
      if request.headers['X-API-KEY'].present?
        @token = request.headers['X-API-KEY'].to_s
        @user  = User.find_by_apiKey(@token)
        if !@user.nil?
          if Reply.exists?(params[:id])
            @reply = Reply.find(params[:id])
            @like = Like.where(reply_id: @reply.id, user_id: @user.id).first
            if !@like.nil?
              @like.delete
              @reply.points -= 1
              @reply.save
              @user.karma -= 1
              @user.save
              format.json { render json:{status:"ok", code:204, message: "Reply unvoted successfully"}, status: :no_content}
            else
              format.json { render json:{status:"error", code:404, message: "Reply has not been voted by user"}, status: :not_found}
            end
          else
            format.json { render json:{status:"error", code:404, message: "Reply with id " + params[:id] + " not found"}, status: :not_found}
          end
        else
          format.json { render json:{status:"error", code:403, message: "Your api key " + @token + " is not valid"}, status: :forbidden}
        end
      end
      format.json { render json:{status:"error", code:401, message: "You provided no api key"}, status: :unauthorized}
    end
  end

end