class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, :keys => [:username, :first_name, :last_name, :location])

    devise_parameter_sanitizer.permit(:account_update, :keys => [:username, :first_name, :last_name, :location, :bio, :photo])
  end


end
