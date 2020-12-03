class RepliesController < ApplicationController
  before_action :set_reply, only: [:show, :edit, :update, :destroy, :replyrecursive]

  # GET /replies
  # GET /replies.json
  def index
    @replies = Reply.all
  end

  # GET /replies/1
  # GET /replies/1.json
  def show
    if current_user.nil?
      redirect_to user_google_oauth2_omniauth_authorize_path
    else
      @replyChild = Reply.new
      @like = Like.new
      @likes = Like.new
      if !current_user.nil?
        @likes = Like.where(user_id: current_user.id)
      end
    end
  end

  # GET /replies/new
  def new
    if current_user.nil?
      redirect_to user_google_oauth2_omniauth_authorize_path
    else
      @reply = Reply.new
      @comment = Comment.find(params[:comment_id])
      @contribution = Contribution.find(params[:contribution_id])
      @like = Like.new
      @likes = Like.new
      if !current_user.nil?
        @likes = Like.where(user_id: current_user.id)
      end
    end
  end

  # GET /replies/1/edit
  def edit
    @like = Like.new
    @likes = Like.new
    if !current_user.nil?
      @likes = Like.where(user_id: current_user.id)
    end
  end

  # POST /replies
  # POST /replies.json
  def replyrecursive
    if current_user.nil?
      redirect_to user_google_oauth2_omniauth_authorize_path
    else
      @reply = Reply.new(reply_params)
      @reply.user_id = current_user.id
      
      respond_to do |format|
        if @reply.save
          format.html { redirect_to "/"+ @reply.findContribution(@reply.id).to_s}
          format.json { render :show, status: :created, location: @reply }
        else
          format.html { redirect_to Reply.find(@reply.reply_id), notice: "Reply can't be blank" }
          format.json { render json: @reply.errors, status: :unprocessable_entity }
        end
      end
    end
  end
  
  
  def create
    if current_user.nil?
      redirect_to user_google_oauth2_omniauth_authorize_path
    else
      @reply = Reply.new(reply_params)
      @reply.user_id = current_user.id
      respond_to do |format|
        if @reply.save
          format.html { redirect_to "/"+ @reply.comment.contribution.id.to_s }
          format.json { render :show, status: :created, location: @reply }
        else
          format.html { redirect_to @reply.comment, notice: "Reply can't be blank" }
          format.json { render json: @reply.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /replies/1
  # PATCH/PUT /replies/1.json
  def update
    respond_to do |format|
      if reply_params[:content].blank?
        format.html { redirect_to edit_reply_url(@reply), notice: "Reply can't be blank" }
        format.json { render json: @reply.errors, status: :unprocessable_entity }
      else @reply.update(reply_params)
        format.html { redirect_to @reply, notice: 'Reply was successfully updated.' }
        format.json { render :show, status: :ok, location: @reply }
      end
    end
  end

  # DELETE /replies/1
  # DELETE /replies/1.json
  def destroy
    @reply.destroy
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.json { head :no_content }
    end
  end
  
  def like
    @reply = Reply.find(params[:id])
    @like = Like.where(reply_id: @reply.id, user_id: current_user.id).first
    if @like.nil?
      @like = Like.new
      @like.reply_id = params[:id]
      @like.user_id = current_user.id
      @reply.points += 1
      @reply.save
      @like.save
      @user = User.find(@reply.user_id)
      @user.karma += 1
      @user.save
    end
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.html { notice 'Contribution was successfully liked' }
      format.json { head :no_content }
    end
  end
  
  def dislike
    @reply = Reply.find(params[:id])
    @like = Like.where(reply_id: @reply.id, user_id: current_user.id).first
    if !@like.nil?
      @like.delete
      @reply.points -= 1
      @reply.save
      @user = User.find(@reply.user_id)
      @user.karma -= 1
      @user.save
    end
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.html { notice 'Contribution was successfully disliked' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reply
      @reply = Reply.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def reply_params
      params.require(:reply).permit(:content, :user_id, :comment_id, :reply_id)
    end
end
