class PagesController < ApplicationController
  skip_before_action :configure_permitted_parameters, only: :home

  def home
  end

  def landing
    if user_signed_in?
      redirect_to home_path
    else
      redirect_to new_user_session_path
    end
  end


end
