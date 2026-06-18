class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  before_action :authenticate

  private

  def authenticate
    unless authenticated?
      session[:return_to] = request.fullpath if request.get?
      redirect_to login_path
    end
  end

  def authenticated?
    session[:authenticated].present?
  end
  helper_method :authenticated?
end
