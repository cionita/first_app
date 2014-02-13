module SessionsHelper
# user methods  
  def sign_in_user(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end
  
  def user_signed_in?
    !current_user.nil?
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end
  
  def current_user?(user)
    user == current_user
  end
  
  def sign_out_user
    self.current_user = nil
    cookies.delete(:remember_token)
  end
  
# restaurant methods 
  def sign_in_restaurant(restaurant)
    cookies.permanent[:remember_token] = restaurant.remember_token
    self.current_restaurant = restaurant
  end
  
  def current_restaurant=(restaurant)
    @current_restaurant = restaurant
  end
  
  def current_restaurant
    @current_restaurant ||= Restaurant.find_by_remember_token(cookies[:remember_token])
  end
  
  def current_restaurant?(restaurant)
    restaurant == current_restaurant
  end
  
  def restaurant_signed_in?
    !current_restaurant.nil?
  end
  
  def sign_out_restaurant
    self.current_restaurant = nil
    cookies.delete(:remember_token)
  end
  
#   generic methods
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url
  end
end
