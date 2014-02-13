require 'spec_helper'

describe "Restaurant authentication" do

  subject { page }

  describe "signin page" do
    before { visit restaurant_signin_path }

    it { should have_selector('h1',    text: 'Sign in') }
    it { should have_selector('title', text: 'Sign in') }
  end
  
  describe "signin" do
    before { visit restaurant_signin_path }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_selector('title', text: 'Sign in') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }
      
      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end
    
    describe "with valid information" do
      let(:restaurant) { FactoryGirl.create(:restaurant) }
      before do
        fill_in "Email",    with: restaurant.email.upcase
        fill_in "Password", with: restaurant.password
        click_button "Sign in"
      end

      it { should have_selector('title', text: restaurant.name) }
      it { should have_link('Profile', href: restaurant_path(restaurant)) }
      it { should have_link('Settings', href: edit_restaurant_path(restaurant)) }
      it { should have_link('Sign out', href: restaurant_signout_path) }
      it { should_not have_link('Sign in', href: restaurant_signin_path) }
      
      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
    end
  end
  
  describe "authorization" do

    describe "for non-signed-in restaurants" do
      let(:restaurant) { FactoryGirl.create(:restaurant) }

      describe "in the Restaurants controller" do

        describe "visiting the edit page" do
          before { visit edit_restaurant_path(restaurant) }
          it { should have_selector('title', text: 'Sign in') }
        end

        describe "submitting to the update action" do
          before { put restaurant_path(restaurant) }
          specify { response.should redirect_to(restaurant_signin_path) }
        end
        
        describe "visiting the user index" do
          before { visit restaurants_path }
          it { should have_selector('title', text: 'Sign in') }
        end
      end
    
      describe "when attempting to visit a protected page" do
        before do
          visit edit_restaurant_path(restaurant)
          fill_in "Email",    with: restaurant.email
          fill_in "Password", with: restaurant.password
          click_button "Sign in"
        end

        describe "after signing in" do
          it "should render the desired protected page" do
            page.should have_selector('title', text: 'Edit restaurant')
          end
        end
      end
    end
    
    describe "as wrong restaurant" do
      let(:restaurant) { FactoryGirl.create(:restaurant) }
      let(:wrong_restaurant) { FactoryGirl.create(:restaurant, email: "wrong@restaurant.com") }
      before { sign_in_restaurant restaurant }

      describe "visiting Restaurant#edit page" do
        before { visit edit_restaurant_path(wrong_restaurant) }
        it { should_not have_selector('title', text: full_title('Edit user')) }
      end

      describe "submitting a PUT request to the Restaurant#update action" do
        before { put restaurant_path(wrong_restaurant) }
        specify { response.should redirect_to(root_url) }
      end
    end
  end
end