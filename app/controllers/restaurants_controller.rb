class RestaurantsController < ApplicationController
  before_filter :signed_in_restaurant, only: [:index, :edit, :update]
  before_filter :correct_restaurant,   only: [:edit, :update]
  
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

  # DELETE /restaurants/1
  # DELETE /restaurants/1.json
  # def destroy
    # @restaurant = Restaurant.find(params[:id])
    # @restaurant.destroy
# 
    # respond_to do |format|
      # format.html { redirect_to restaurants_url }
      # format.json { head :no_content }
    # end
  # end
  
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
end
