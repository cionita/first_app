require 'spec_helper'

describe Restaurant do

  before { @restaurant = Restaurant.new(name: "Example Restaurant", email: "info@restaurant.com") }

  subject { @restaurant }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
end