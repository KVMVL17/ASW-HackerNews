class Api::CommentsController < ApplicationController
  
  
  def showComment
    respond_to do |format|
      if Comment.exists?(params[:id])
        @comment = Comment.find(params[:id])
        format.json { render json: @comment, status: :ok}
      else
        format.json { render json:{status:"error", code:404, message: "Comment with ID '" + params[:id] + "' not found"}, status: :not_found}
      end
    end
  end
  
  def showcommentsofuser
    respond_to do |format|
      if User.exists?(params[:id])
        @comments = Comment.where(user_id: params[:id])
        format.json { render json: @comments }
      else
        format.json { render json:{status:"error", code:404, message: "User with ID '" + params[:id].to_s + "' not found"}, status: :not_found}
      end
    end 
  end
  
  def upvoted_comments
    respond_to do |format|
      if request.headers['X-API-KEY'].present?
        @user = User.find_by_apiKey(request.headers['X-API-KEY'].to_s)
        if @user.nil?
          format.json { render json: { status: "error", code: 403, message: "Your api key " + request.headers['X-API-KEY'].to_s + " is not valid"}, status: :forbidden }
        else
          @like = Like.where(user_id: @user.id, contribution_id: nil, reply_id: nil)
          @comments = Comment.none.to_a
          @like.each do |like|
            @comments.push Comment.find(like.comment_id)
          end
          format.json { render json: @comments, status: :ok}
        end
      else
        format.json { render json: { status: "error", code: 401, message: "You provided no api key"}, status: :unauthorized }
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
          
          if !Contribution.exists?(params[:id])
            format.json { render json: { status: "error", code: 404, message: "Contribution with ID: " + params[:id] + " not found"}, status: :not_found }
          else
            @comment = Comment.new
            @comment.content = params[:content]
            @comment.user_id = @user.id
            @comment.contribution_id = params[:id]
              
            if @comment.save
              format.json { render json: @comment, status: :created }
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
          if !Comment.exists?(params[:id])
            format.json { render json: { status: "error", code: 404, message: "Comment with ID: " + params[:id] + " not found"}, status: :not_found }
          else
            @comment = Comment.find(params[:id])
            if @comment.user_id == @user.id
              @comment.content = params[:content]
              if @comment.save
                format.json { render json: @comment, status: :ok }
              else
                format.json { render json: { status: "error", code: 400, message: "Content can't be blank" }, status: :bad_request }
              end
            else
              format.json { render json:{status: "error", code:403, message: "This comment does not belong to you"}, status: :forbidden}
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
          if Comment.exists?(params[:id])
            @comment = Comment.find(params[:id])
            if @comment.user_id == @user.id
              @comment.destroy
              format.json { render json: { status: "no content", code: 204, message: "Comment deleted" }, status: :no_content }
            else
              format.json { render json:{status: "error", code:403, message: "This comment does not belong to you"}, status: :forbidden}
            end
          else
            format.json { render json: { status: "error", code: 404, message: "Comment with ID: " + params[:id] + " not found" }, status: :not_found }
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
          if Comment.exists?(params[:id])
            @comment = Comment.find(params[:id])
            @like = Like.where(comment_id: @comment.id, user_id: @user.id).first
            if @like.nil?
              @like = Like.new
              @like.comment_id= params[:id]
              @like.user_id = @user.id
              @comment.points += 1
              @comment.save
              @like.save
              @user.karma +=1
              @user.save
              format.json { render json: @comment, status: :created}
            else
              format.json { render json:{status:"error", code:404, message: "Comment already voted"}, status: :not_found}
            end
          else
            format.json { render json:{status:"error", code:404, message: "Comment with id " + params[:id] + " not found"}, status: :not_found}
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
          if Comment.exists?(params[:id])
            @comment = Comment.find(params[:id])
            @like = Like.where(comment_id: @comment.id, user_id: @user.id).first
            if !@like.nil?
              @like.delete
              @comment.points -= 1
              @comment.save
              @user.karma -= 1
              @user.save
              format.json { render json:{status:"ok", code:204, message: "Comment unvoted successfully"}, status: :no_content}
            else
              format.json { render json:{status:"error", code:404, message: "Comment has not been voted by user"}, status: :not_found}
            end
          else
            format.json { render json:{status:"error", code:404, message: "Comment with id " + params[:id] + " not found"}, status: :not_found}
          end
        else
          format.json { render json:{status:"error", code:403, message: "Your api key " + @token + " is not valid"}, status: :forbidden}
        end
      end
      format.json { render json:{status:"error", code:401, message: "You provided no api key"}, status: :unauthorized}
    end
  end

end