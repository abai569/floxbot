class SessionsController < ApplicationController
  skip_before_action :authenticate, only: [ :new, :create ]
  allow_browser versions: :modern

  def new
    redirect_to root_path if authenticated?
  end

  def create
    expected_username = ENV["ADMIN_USERNAME"].presence
    expected_password = ENV["ADMIN_PASSWORD"].presence

    if expected_username.blank? || expected_password.blank?
      Rails.logger.error "Authentication credentials not configured."
      flash.now[:alert] = I18n.t("sessions.new.error")
      render :new, status: :unprocessable_entity and return
    end

    if ActiveSupport::SecurityUtils.secure_compare(params[:username].to_s, expected_username) &
       ActiveSupport::SecurityUtils.secure_compare(params[:password].to_s, expected_password)
      session[:authenticated] = true
      redirect_to root_path, notice: "登录成功"
    else
      flash.now[:alert] = I18n.t("sessions.new.error")
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:authenticated] = nil
    redirect_to login_path, notice: "已退出登录"
  end
end
