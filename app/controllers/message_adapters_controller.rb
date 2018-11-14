class MessageAdaptersController < ApplicationController
  before_action :set_message_adapter, only: [:show, :edit, :update, :destroy]

  # GET /file_adapters
  # GET /file_adapters.json
  def index
    @message_adapters = MessageAdapter.all
  end

  # GET /file_adapters/1
  # GET /file_adapters/1.json
  def show
  end

  # GET /file_adapters/new
  def new
    @message_adapter = MessageAdapter.new
  end

  # GET /file_adapters/1/edit
  def edit
  end

  # POST /file_adapters
  # POST /file_adapters.json
  def create
    @message_adapter = MessageAdapter.new(message_adapter_params)

    respond_to do |format|
      if @file_adapter.save
        format.html { redirect_to @file_adapter, notice: 'Message adapter was successfully created.' }
        format.json { render :show, status: :created, location: @message_adapter }
      else
        format.html { render :new }
        format.json { render json: @message_adapter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /file_adapters/1
  # PATCH/PUT /file_adapters/1.json
  def update
    respond_to do |format|
      if @message_adapter.update(message_adapter_params)
        format.html { redirect_to @message_adapter, notice: 'Message adapter was successfully updated.' }
        format.json { render :show, status: :ok, location: @message_adapter }
      else
        format.html { render :edit }
        format.json { render json: @message_adapter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /file_adapters/1
  # DELETE /file_adapters/1.json
  def destroy
    @message_adapter.destroy
    respond_to do |format|
      format.html { redirect_to message_adapters_url, notice: 'Message adapter was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message_adapter
      @message_adapter = MessageAdapter.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_adapter_params
      params.require(:message_adapter).permit(:title, :created_by)
    end
end
