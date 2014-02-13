class RestaurantsController < ApplicationController
  before_filter :signed_in_restaurant,   only: [:edit, :update]
  before_filter :correct_restaurant,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy
  
  def index
    @restaurants = Restaurant.paginate(page: params[:page])
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def new
    @restaurant = Restaurant.new
  end
  
  def create
    @restaurant = Restaurant.new(params[:restaurant])
    if @restaurant.save
      sign_in_restaurant @restaurant
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @restaurant
    else
      render 'new'
    end
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
  end

  def update
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.update_attributes(params[:restaurant])
      flash[:success] = "Profile updated"
      sign_in_restaurant @restaurant
      redirect_to @restaurant
    else
      render 'edit'
    end
  end

  def destroy
    Restaurant.find(params[:id]).destroy
    flash[:success] = "Restaurant destroyed."
    redirect_to restaurants_url
  end
  
  private

    def signed_in_restaurant
      unless restaurant_signed_in?
        store_location
        redirect_to restaurant_signin_url, notice: "Please sign in."
      end
    end
    
    def correct_restaurant
      @restaurant = Restaurant.find(params[:id])
      redirect_to(root_url) unless current_restaurant?(@restaurant)
    end
    
    def admin_user
      redirect_to(root_url) unless current_user && current_user.admin?
    end
end
