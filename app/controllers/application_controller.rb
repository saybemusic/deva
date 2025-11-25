class ApplicationController < ActionController::Base
  # [...]
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :resource, :resource_name, :devise_mapping

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])

    # For additional in app/views/devise/registrations/edit.html.erb
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end


  # private

  # def resource
  #   @resource
  # end

  # def resource_name
  #   @resource_name
  # end

  # def devise_mapping
  #   @devise_mapping
  # end

end
