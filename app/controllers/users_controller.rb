class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html
      format.json do
        query = '*'
        if params[:q].present?
          query = params[:q]
        end

        # TODO: 表示できる最大件数の定義をどこかでする
        response = User.search(query).page(1).per(5000)

        total_records = response.records.total
        users = response.results.map { |r| r._source }

        logger.info "total result: #{response.records.total}"

        render json: {records: users, total_records: total_records}
      end
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    #random_password = SecureRandom.urlsafe_base64(7)
    #@user.password = random_password
    #logger.info("p=#{random_password}")

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def show

  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:username, :email, :personid, :cardid,
                                 :full_name, :full_name_transcription,
                                 :expired_at, :registration_date, :note, :deactive, :password)
  end
end
