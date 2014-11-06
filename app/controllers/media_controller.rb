class MediaController < ApplicationController
  before_action :set_medium, only: [:show, :edit, :update, :destroy]

  # GET /media
  # GET /media.json
  def index
    @media = Medium.all
  end

  # GET /media/1
  # GET /media/1.json
  def show
  end

  # GET /media/new
  def new
    @medium = Medium.new
  end

  # GET /media/1/edit
  def edit
  end

  # POST /media/get_media.json
  def get_media
    @media_to_show = Array.new
    @media_to_show = Medium.where("approve_state = ? AND show_state = ?", "Por Aprobación", "No Mostrado").order(created_at: :desc)
    respond_to do |format|
      format.json { render json: @media_to_show } 
    end
  end
  
  # POST /media/approve_media
  def approve_media
    id = params[:id]
    origin = params[:origin]
    media=Medium.find_by("id_media = ? AND social_net_origin =?", id, origin)
    media.approve_state = "Aprobado"
    respond_to do |format|
      if (media.save)
        format.html {render json: "Completo"}
      else
        format.html {render json: "Error"}
      end
    end
  end

  def disapprove_media
    id = params[:id]
    origin = params[:origin]
    media=Medium.find_by("id_media = ? AND social_net_origin =?", id, origin)
    media.approve_state = "No Aprobado"
    respond_to do |format|
      if (media.save)
        format.html {render json: "Completo"}
      else
        format.html {render json: "Error"}
      end
    end
  end


  def show_media
    @media_to_show = Array.new
    @media_to_show = Medium.where("approve_state = ? AND show_state = ?", "Aprobado", "No Mostrado")
    respond_to do |format|
      format.html { }
      format.json { render json: @media_to_show } 
    end
  end

  # POST /media
  # POST /media.json
  def create
    @medium = Medium.new(medium_params)

    respond_to do |format|
      if @medium.save
        format.html { redirect_to @medium, notice: 'Medium was successfully created.' }
        format.json { render :show, status: :created, location: @medium }
      else
        format.html { render :new }
        format.json { render json: @medium.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /media/1
  # PATCH/PUT /media/1.json
  def update
    respond_to do |format|
      if @medium.update(medium_params)
        format.html { redirect_to @medium, notice: 'Medium was successfully updated.' }
        format.json { render :show, status: :ok, location: @medium }
      else
        format.html { render :edit }
        format.json { render json: @medium.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /media/1
  # DELETE /media/1.json
  def destroy
    @medium.destroy
    respond_to do |format|
      format.html { redirect_to media_url, notice: 'Medium was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_medium
      @medium = Medium.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def medium_params
      params.require(:medium).permit(:id_media, :user, :text, :image_url, :approve_state, :show_state, :social_net_origin, :media_created_at)
    end
end
