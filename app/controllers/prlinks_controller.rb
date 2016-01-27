class PrlinksController < ApplicationController
  before_action :set_prlink, only: [:show, :edit, :update, :destroy]

  # GET /prlinks
  # GET /prlinks.json
  def index
    @prlinks = Prlink.all
  end

  # GET /prlinks/1
  # GET /prlinks/1.json
  def show
  end

  # GET /prlinks/new
  def new
    @prlink = Prlink.new
  end

  # GET /prlinks/1/edit
  def edit
  end

  # POST /prlinks
  # POST /prlinks.json
  def create
    @prlink = Prlink.new(prlink_params)

    respond_to do |format|
      if @prlink.save
        format.html { redirect_to @prlink, notice: 'Prlink was successfully created.' }
        format.json { render :show, status: :created, location: @prlink }
      else
        format.html { render :new }
        format.json { render json: @prlink.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /prlinks/1
  # PATCH/PUT /prlinks/1.json
  def update
    respond_to do |format|
      if @prlink.update(prlink_params)
        format.html { redirect_to @prlink, notice: 'Prlink was successfully updated.' }
        format.json { render :show, status: :ok, location: @prlink }
      else
        format.html { render :edit }
        format.json { render json: @prlink.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prlinks/1
  # DELETE /prlinks/1.json
  def destroy
    @prlink.destroy
    respond_to do |format|
      format.html { redirect_to prlinks_url, notice: 'Prlink was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prlink
      @prlink = Prlink.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def prlink_params
      params.require(:prlink).permit(:region_id, :operator_id, :link1, :link2, :link3, :link4)
    end
end
