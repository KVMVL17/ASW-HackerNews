class Api::ContributionsController < ApplicationController
  
  def initialize(headers = {})
    @headers = headers
  end

  # GET /api/v1/contributions
  # GET /api/v1/contributions.json
  def index
    @contributions = Contribution.where(text:"").order(points: :desc)
    respond_to do |format|
      format.json { render json: @contributions}
    end
  end

  # GET /api/v1/contributions/1
  # GET /api/v1/contributions/1.json
  def show
    @aux = Contribution.exists?(params[:id])
    respond_to do |format|
      if @aux
        @contribution = Contribution.find(params[:id])
        format.json { render json: @contribution}
      else
        format.json { render json:{status:"error", code:404, message: "Contribution with ID '" + params[:id].to_s + "' not found"}, status: :not_found}
      end
    end
  end

  # GET /api/v1/contributions/new
  def new
    @api_v1_contribution = Api::Contribution.new
  end
  
  def newest
    @contributions = Contribution.all.order(created_at: :desc)
    respond_to do |format|
      format.json { render json: @contributions}
    end
  end
  
  def ask
    @contributions = Contribution.where(url: "").order(points: :desc)
    respond_to do |format|
      format.json { render json: @contributions}
    end
  end
  
  def showcontributionsofuser
    @contributions = Contribution.where(user_id: params[:id])
    respond_to do |format|
      format.json { render json: @contributions }
    end 
  end

  # GET /api/v1/contributions/1/edit
  def edit
  end

  # POST /api/v1/contributions
  # POST /api/v1/contributions.json
  def create
    @api_v1_contribution = Api::Contribution.new(api_v1_contribution_params)

    respond_to do |format|
      if @api_v1_contribution.save
        format.html { redirect_to @api_v1_contribution, notice: 'Contribution was successfully created.' }
        format.json { render :show, status: :created, location: @api_v1_contribution }
      else
        format.html { render :new }
        format.json { render json: @api_v1_contribution.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /api/v1/contributions/1
  # PATCH/PUT /api/v1/contributions/1.json
  def update
    respond_to do |format|
      if @api_v1_contribution.update(api_v1_contribution_params)
        format.html { redirect_to @api_v1_contribution, notice: 'Contribution was successfully updated.' }
        format.json { render :show, status: :ok, location: @api_v1_contribution }
      else
        format.html { render :edit }
        format.json { render json: @api_v1_contribution.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /api/v1/contributions/1
  # DELETE /api/v1/contributions/1.json
  def destroy
    @api_v1_contribution.destroy
    respond_to do |format|
      format.html { redirect_to api_v1_contributions_url, notice: 'Contribution was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def like
    respond_to do |format|
      if request.headers['X-API-KEY'].present?
        @token = request.headers['X-API-KEY'].to_s
        @user  = User.find_by_apiKey(@token)
        if !@user.nil?
          if Contribution.exists?(params[:id])
            @contribution = Contribution.find(params[:id])
            @like = Like.where(contribution_id: @contribution.id, user_id: @user.id).first
            if @like.nil?
              @like = Like.new
              @like.contribution_id = params[:id]
              @like.user_id = @user.id
              @contribution.points += 1
              @contribution.save
              @like.save
              @user.karma +=1
              @user.save
              format.json { render json: @contribution, status: :created}
            else
              format.json { render json:{status:"error", code:208, message: "contribution already voted"}, status: :already_reported}
            end
          else
            format.json { render json:{status:"error", code:404, message: "Contribution with id " + params[:id] + " not found"}, status: :not_found}
          end
          
        else
          format.json { render json:{status:"error", code:400, message: "token not found"}, status: :bad_request}
        end
      end
    end
  end
  
  
  def dislike
    respond_to do |format|
      if request.headers['X-API-KEY'].present?
        @token = request.headers['X-API-KEY'].to_s
        @user  = User.find_by_apiKey(@token)
        if !@user.nil?
          if Contribution.exists?(params[:id])
            @contribution = Contribution.find(params[:id])
            @like = Like.where(contribution_id: @contribution.id, user_id: @user.id).first
            if !@like.nil?
              @like.delete
              @contribution.points -= 1
              @contribution.save
              @user.karma -= 1
              @user.save
              format.json { render json:{status:"ok", code:204, message: "contribution unvoted successfully"}, status: :no_content}
            else
              format.json { render json:{status:"error", code:404, message: "contribution has not been voted by user"}, status: :not_found}
            end
          else
            format.json { render json:{status:"error", code:404, message: "Contribution with id " + params[:id] + " not found"}, status: :not_found}
          end
        else
          format.json { render json:{status:"error", code:403, message: "Your api key " + @token + " is not valid"}, status: :forbidden}
        end
      end
      format.json { render json:{status:"error", code:401, message: "You provided no api key"}, status: :unauthorized}
    end
  end
  
  def create
    respond_to do |format|
      if request.headers['X-API-KEY'].present?
        @user = User.find_by_apiKey(request.headers['X-API-KEY'].to_s)
        if @user.nil?
          format.json { render json:{status:"error", code:403, message: "Your api key " + request.headers['X-API-KEY'].to_s + " is not valid"}, status: :forbidden}
        else
          if Contribution.find_by_url(params[:url]).nil? || params[:url].blank?
            @NContribution = Contribution.new
            @NContribution.title = params[:title]
            @NContribution.url = params[:url]
            @NContribution.text = params[:text]#se puede poner en el else
            @NContribution.user_id = @user.id
            if !params[:url].blank? && !params[:text].blank?
              @NContribution.text = ""
              @comment = Comment.new
              @comment.content = params[:text]
              @comment.user_id = @user.id
            end
            
            if @NContribution.save
              if !params[:url].blank? && !params[:text].blank?
                @comment.contribution_id = @NContribution.id
                @comment.save
              end
              format.json { render json: @NContribution, status: :created}
            else #aqui ya existe la url o hay algún fallo
              if params[:title].blank?
                format.json { render json: {status:"error", code:400, message: "Title can't be blank"}, status: :bad_request }
              elsif params[:url].blank? && params[:text].blank?
                format.json { render json: {status:"error", code:400, message: "URL and Text can't be blank at the same time"}, status: :bad_request }
              else
                format.json { render json: {status:"error", code:400, message: "URL not valid"}, status: :bad_request }
              end
              format.json { render json: {status:"error", code:401, message: "You provided no api key"}, status: :unprocessable_entity }
            end
          else
            format.json { render json: Contribution.find_by_url(params[:url]), status: :ok }
          end
        end
      else
        format.json { render json:{status:"error", code:401, message: "You provided no api key"}, status: :unauthorized}
      end
    end
  end
  
  

  private

    # Only allow a list of trusted parameters through.
    def api_v1_contribution_params
      params.fetch(:api_v1_contribution, {})
    end
end
