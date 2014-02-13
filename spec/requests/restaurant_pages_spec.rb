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
  
  describe "edit" do
    let(:restaurant) { FactoryGirl.create(:restaurant) }
    before do
      sign_in_restaurant restaurant
      visit edit_restaurant_path(restaurant)
    end

    describe "page" do
      it { should have_selector('h1',    text: "Update restaurant profile") }
      it { should have_selector('title', text: "Edit restaurant") }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end
    
    describe "with valid information" do
      let(:new_name)  { "New restaurant" }
      let(:new_email) { "info@newrestaurant.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: restaurant.password
        fill_in "Confirm Password", with: restaurant.password
        click_button "Save changes"
      end

      it { should have_selector('title', text: new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: restaurant_signout_path) }
      specify { restaurant.reload.name.should  == new_name }
      specify { restaurant.reload.email.should == new_email }
    end
  end
  
  describe "index" do
    
    let(:restaurant) { FactoryGirl.create(:restaurant) }

    before do
      visit restaurants_path
    end
    
    it { should have_selector('title', text: 'All restaurants') }
    it { should have_selector('h1',    text: 'All restaurants') }
    
    describe "pagination" do

      before(:all) { 60.times { FactoryGirl.create(:restaurant) } }
      after(:all)  { Restaurant.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each restaurant" do
        Restaurant.paginate(page: 1).each do |restaurant|
          page.should have_selector('li', text: restaurant.name)
        end
      end
    end
    
    describe "delete links" do
      
      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        
        before(:all) { 5.times { FactoryGirl.create(:restaurant) } }
        after(:all)  { Restaurant.delete_all }

        before do
          sign_in_user admin
          visit restaurants_path
        end

        it { should have_link('delete', href: restaurant_path(Restaurant.first)) }
        
        it "should be able to delete a restaurant" do
          expect { click_link('delete') }.to change(Restaurant, :count).by(-1)
        end
      end
    end
    
  end
end