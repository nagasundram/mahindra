class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

   rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
   end

   rescue_from ActiveSupport::MessageVerifier::InvalidSignature do |exception|
    redirect_to root_url
   end

   def encrypt_data(data)
    crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base)
    return crypt.encrypt_and_sign(data)
  end

  def decrypt_data(data)
     crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base)
     return crypt.decrypt_and_verify(data)
  end

  helper_method :encrypt_data, :decrypt_data

end
