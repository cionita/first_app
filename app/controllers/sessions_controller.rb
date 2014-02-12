class SessionsController < ApplicationController
  
  def new_user
  end
  
  def new_restaurant
  end

  def create
    if params[:session][:type] == 'user'
      user = User.find_by_email(params[:session][:email].downcase)
      if user && user.authenticate(params[:session][:password])
        sign_in_user user
        redirect_back_or user
      else
        flash.now[:error] = 'Invalid email/password combination'
        render 'new_user'
      end
    elsif params[:session][:type] == 'restaurant'
      restaurant = Restaurant.find_by_email(params[:session][:email].downcase)
      if restaurant && restaurant.authenticate(params[:session][:password])
        sign_in_restaurant restaurant
        redirect_back_or restaurant
      else
        flash.now[:error] = 'Invalid email/password combination'
        render 'new_restaurant'
      end
    end
  end

  def destroy_user
    sign_out_user
    redirect_to root_path
  end
  
  def destroy_restaurant
    sign_out_restaurant
    redirect_to root_path
  end
  
end
