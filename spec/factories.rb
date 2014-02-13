FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end
end

FactoryGirl.define do
  factory :restaurant do
    sequence(:name)  { |n| "Restaurant #{n}" }
    sequence(:email) { |n| "restaurant_#{n}@foodoracle.com"}
    password "foobar"
    password_confirmation "foobar"
  end
end