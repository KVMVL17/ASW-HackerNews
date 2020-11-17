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
    @replyChild = Reply.new
  end

  # GET /replies/new
  def new
    @reply = Reply.new
    @comment = Comment.find(params[:comment_id])
    @contribution = Contribution.find(params[:contribution_id])
  end

  # GET /replies/1/edit
  def edit
  end

  # POST /replies
  # POST /replies.json
  def replyrecursive
    @reply = Reply.new(reply_params)
    @reply.creator = current_user.email
    
    respond_to do |format|
      if @reply.save
        format.html { redirect_to @reply, notice: 'Reply was successfully created.' }
        format.json { render :show, status: :created, location: @reply }
      else
        format.html { render :new }
        format.json { render json: @reply.errors, status: :unprocessable_entity }
      end
    end
  end
  
  
  def create
    @reply = Reply.new(reply_params)
    @reply.creator = current_user.email
    
    respond_to do |format|
      if @reply.save
        format.html { redirect_to @reply, notice: 'Reply was successfully created.' }
        format.json { render :show, status: :created, location: @reply }
      else
        format.html { render :new }
        format.json { render json: @reply.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /replies/1
  # PATCH/PUT /replies/1.json
  def update
    respond_to do |format|
      if @reply.update(reply_params)
        format.html { redirect_to @reply, notice: 'Reply was successfully updated.' }
        format.json { render :show, status: :ok, location: @reply }
      else
        format.html { render :edit }
        format.json { render json: @reply.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /replies/1
  # DELETE /replies/1.json
  def destroy
    @reply.destroy
    respond_to do |format|
      format.html { redirect_to replies_url, notice: 'Reply was successfully destroyed.' }
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
      params.require(:reply).permit(:content, :creator, :comment_id, :reply_id)
    end
end
