class FileAdaptersController < ApplicationController
  before_action :set_file_adapter, only: [:show, :edit, :update, :destroy]

  # GET /file_adapters
  # GET /file_adapters.json
  def index
    @file_adapters = FileAdapter.all
  end

  # GET /file_adapters/1
  # GET /file_adapters/1.json
  def show
  end

  # GET /file_adapters/new
  def new
    @file_adapter = FileAdapter.new
  end

  # GET /file_adapters/1/edit
  def edit
  end

  # POST /file_adapters
  # POST /file_adapters.json
  def create
    @file_adapter = FileAdapter.new(file_adapter_params)

    respond_to do |format|
      if @file_adapter.save
        format.html { redirect_to @file_adapter, notice: 'File adapter was successfully created.' }
        format.json { render :show, status: :created, location: @file_adapter }
      else
        format.html { render :new }
        format.json { render json: @file_adapter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /file_adapters/1
  # PATCH/PUT /file_adapters/1.json
  def update
    respond_to do |format|
      if @file_adapter.update(file_adapter_params)
        format.html { redirect_to @file_adapter, notice: 'File adapter was successfully updated.' }
        format.json { render :show, status: :ok, location: @file_adapter }
      else
        format.html { render :edit }
        format.json { render json: @file_adapter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /file_adapters/1
  # DELETE /file_adapters/1.json
  def destroy
    @file_adapter.destroy
    respond_to do |format|
      format.html { redirect_to file_adapters_url, notice: 'File adapter was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_file_adapter
      @file_adapter = FileAdapter.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def file_adapter_params
      params.require(:file_adapter).permit(:title, :created_by)
    end
end
