require 'spec_helper'

describe "Restaurant pages" do

  subject { page }

  describe "signup page" do
    before { visit restaurant_signup_path }

    it { should have_selector('h1',    text: 'Register your restaurant') }
    it { should have_selector('title', text: full_title('Register your restaurant')) }
  end
  
  describe "profile page" do
    let(:restaurant) { FactoryGirl.create(:restaurant) }
    before { visit restaurant_path(restaurant) }
  
    it { should have_selector('h1',    text: restaurant.name) }
    it { should have_selector('title', text: restaurant.name) }
  end
  
  describe "signup" do

    before { visit restaurant_signup_path }

    let(:submit) { "Register" }

    describe "with invalid information" do
      it "should not create a restaurant" do
        expect { click_button submit }.not_to change(Restaurant, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: "Restaurant"
        fill_in "Email",        with: "info@restaurant.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a restaurant" do
        expect { click_button submit }.to change(Restaurant, :count).by(1)
      end
      
      describe "after saving the restaurant" do
        before { click_button submit }
        let(:restaurant) { Restaurant.find_by_email('info@restaurant.com') }

        it { should have_selector('title', text: restaurant.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
        it { should have_link('Sign out') }
      end
    end
  end
end