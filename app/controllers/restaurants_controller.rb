class RestaurantsController < ApplicationController
  # GET /restaurants
  # GET /restaurants.json
  # def index
    # @restaurants = Restaurant.all
# 
    # respond_to do |format|
      # format.html # index.html.erb
      # format.json { render json: @restaurants }
    # end
  # end

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

  # GET /restaurants/1/edit
  # def edit
    # @restaurant = Restaurant.find(params[:id])
  # end

  # PUT /restaurants/1
  # PUT /restaurants/1.json
  # def update
    # @restaurant = Restaurant.find(params[:id])
# 
    # respond_to do |format|
      # if @restaurant.update_attributes(params[:restaurant])
        # format.html { redirect_to @restaurant, notice: 'Restaurant was successfully updated.' }
        # format.json { head :no_content }
      # else
        # format.html { render action: "edit" }
        # format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      # end
    # end
  # end

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
end
