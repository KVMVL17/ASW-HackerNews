class Api::UsersController < ApplicationController

  # GET /api/v1/contributions
  # GET /api/v1/contributions.json
  def index
    @users = User.all
  end

  # GET /api/v1/contributions/1
  # GET /api/v1/contributions/1.json
  def show
    respond_to do |format|
      if User.exists?(params[:id])
        @user = User.find(params[:id])
        format.json { render json: @user, status: :ok}
      else
        format.json { render json: {error: "error", code: 404, message: "User with id: " + params[:id].to_s + " does not exist"}, status: :not_found}
      end
    end
  end

  # GET /api/v1/contributions/new
  def new
    @user = User.new
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
  
  def updateprofile
    
    @user.about = @updateduser.about
    @user.save
    respond_to do |format|
      if User.exists?(params[:id])
        @user = User.find(params[:id])
        format.json { render json: @user, status: :ok}
      else
        format.json { render json: {error: "error", code: 404, message: "User with id: " + params[:id].to_s + " does not exist"}, status: :not_found}
      end
      
    end
  end

  private

    # Only allow a list of trusted parameters through.
    def api_v1_contribution_params
      params.fetch(:api_v1_contribution, {})
    end
end
