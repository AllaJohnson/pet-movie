class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_filter :configure_permited_parameters, if: :devise_controller?

  protected

  def configure_permited_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:email, :password,
      :password_confirmation, :current_password, :title, :logo)}
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:email, :password,
      :password_confirmation, :current_password, :name, :photo, :tell_something) }
  end
end
