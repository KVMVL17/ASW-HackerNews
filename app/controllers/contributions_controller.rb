class ContributionsController < ApplicationController
  before_action :set_contribution, only: [:show, :edit, :update, :destroy]

  # GET /contributions
  # GET /contributions.json
  def index
    @contributions = Contribution.where(text:"").order(points: :desc)
    @like = Like.new
    @likes = Like.new
    if !current_user.nil?
      @likes = Like.where(user_id: current_user.id)
    end
  end

  # GET /contributions/1
  # GET /contributions/1.json
  def show
    @contribution = Contribution.find(params[:id])
    @comment = Comment.new
    
  end
  # GET /contributions/new
  def new
    if current_user.nil?
      redirect_to user_google_oauth2_omniauth_authorize_path
    else
      @contribution = Contribution.new
    end 
  end
  
  def newest
    @contributions = Contribution.all.order(created_at: :desc)
    @like = Like.new
    @likes = Like.new
    if !current_user.nil?
      @likes = Like.where(user_id: current_user.id)
    end
  end

  # GET /contributions/1/edit
  def edit
  end

  # POST /contributions
  # POST /contributions.json
  def create
    if Contribution.find_by_url(contribution_params[:url]).nil? || contribution_params[:url].blank?
      @contribution = Contribution.new(contribution_params)
      @contribution.creator = current_user.email
  
      respond_to do |format|
        if @contribution.save
          format.html { redirect_to :newest }
          format.html { notice 'Contribution was successfully created.' }
        else
          format.html { render :new }
          format.json { render json: @contribution.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to :submit, notice: 'Url already exists' }
        format.json { render json: @contribution.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contributions/1
  # PATCH/PUT /contributions/1.json
  def update
    respond_to do |format|
      if @contribution.update(contribution_params)
        format.html { redirect_to @contribution, notice: 'Contribution was successfully updated.' }
        format.json { render :show, status: :ok, location: @contribution }
      else
        format.html { render :edit }
        format.json { render json: @contribution.errors, status: :unprocessable_entity }
      end
    end
  end 

  # DELETE /contributions/1
  # DELETE /contributions/1.json
  def destroy
    @contribution.destroy
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.html { notice 'Contribution was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def like
    @contribution = Contribution.find(params[:id])
    @like = Like.where(contribution_id: @contribution.id, user_id: current_user.id).first
    if @like.nil?
      @like = Like.new
      @like.contribution_id = params[:id]
      @like.user_id = current_user.id
      @contribution.points += 1
      @contribution.save
      @like.save
    end
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.html { notice 'Contribution was successfully liked' }
      format.json { head :no_content }
    end
  end
  
  
  def dislike
    @contribution = Contribution.find(params[:id])
    @like = Like.where(contribution_id: @contribution.id, user_id: current_user.id).first
    if !@like.nil?
      @like.delete
      @contribution.points -= 1
      @contribution.save
    end
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.html { notice 'Contribution was successfully disliked' }
      format.json { head :no_content }
    end
  end
    

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contribution
      @contribution = Contribution.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def contribution_params
      params.require(:contribution).permit(:title, :url, :text, :points)
    end
end
