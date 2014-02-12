class SessionsController < ApplicationController
  
  def new_user
  end
  
  def new_restaurant
  end

  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or user
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new_user'
    end
  end

  def destroy_user
    sign_out
    redirect_to root_path
  end
  
  def destroy_restaurant
  end
  
end
