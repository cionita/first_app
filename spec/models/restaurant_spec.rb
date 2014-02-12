require 'spec_helper'

describe Restaurant do

  before do
    @restaurant = Restaurant.new(name: "Example Restaurant", email: "info@restaurant.com",
                     password: "foobar", password_confirmation: "foobar")
  end
  
  subject { @restaurant }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  
  it { should be_valid }

  describe "when name is not present" do
    before { @restaurant.name = " " }
    it { should_not be_valid }
  end
  
  describe "when name is too long" do
    before { @restaurant.name = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @restaurant.email = invalid_address
        @restaurant.should_not be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @restaurant.email = valid_address
        @restaurant.should be_valid
      end
    end
  end
  
  describe "when email address is already taken" do
    before do
      restaurant_with_same_email = @restaurant.dup
      restaurant_with_same_email.email = @restaurant.email.upcase
      restaurant_with_same_email.save
    end

    it { should_not be_valid }
  end
  
  describe "when password is not present" do
    before { @restaurant.password = @restaurant.password_confirmation = " " }
    it { should_not be_valid }
  end
  
  describe "when password doesn't match confirmation" do
    before { @restaurant.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end
  
  describe "when password confirmation is nil" do
    before { @restaurant.password_confirmation = nil }
    it { should_not be_valid }
  end
  
  describe "with a password that's too short" do
    before { @restaurant.password = @restaurant.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  describe "return value of authenticate method" do
    before { @restaurant.save }
    let(:found_restaurant) { Restaurant.find_by_email(@restaurant.email) }

    describe "with valid password" do
      it { should == found_restaurant.authenticate(@restaurant.password) }
    end

    describe "with invalid password" do
      let(:restaurant_for_invalid_password) { found_restaurant.authenticate("invalid") }

      it { should_not == restaurant_for_invalid_password }
      specify { restaurant_for_invalid_password.should be_false }
    end
  end
  
  describe "remember token" do
    before { @restaurant.save }
    its(:remember_token) { should_not be_blank }
  end
end