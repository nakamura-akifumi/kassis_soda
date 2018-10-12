class UsersController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json do
        @users = User.select(:username, :full_name, :full_name_transcription, :cardid, :personid, :id)
        render json: @users
      end
    end
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end
end
