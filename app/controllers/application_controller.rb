class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  # Force signout to prevent CSRF attacks
  def handle_unverified_request
    if params[:session][:type] == 'user'
      sign_out
      super
    end
  end
end
