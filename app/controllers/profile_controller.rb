class ProfileController < ApplicationController
  def edit
    @user = current_user
  end

  def update

    unless current_user.valid_password?(user_params)
      render :status => 400, :json => {result: "ng", message: current_user.errors.messages}
      return
    end

    current_user.password = params[:password]
    current_user.update_ldap_password

    render :status => 200, :json => {result: "ok", message: "パスワード更新をしました。", profile: current_user}
  end

  private
  def user_params
    params.permit(:password, :password_confirmation)
  end
end
