def full_title(page_title)
  base_title = "Ruby on Rails Tutorial Sample App"
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end

def sign_in_user(user)
  visit signin_path
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
  # Sign in when not using Capybara as well.
  cookies[:remember_token] = user.remember_token
end

def sign_in_restaurant(restaurant)
  visit restaurant_signin_path
  fill_in "Email",    with: restaurant.email
  fill_in "Password", with: restaurant.password
  click_button "Sign in"
  # Sign in when not using Capybara as well.
  cookies[:remember_token] = restaurant.remember_token
end