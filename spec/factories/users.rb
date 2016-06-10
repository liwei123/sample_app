FactoryGirl.define do
  factory :user do |f|
    f.name "Example User"
    f.email "user@example.com"
    f.password "foobar"
    f.password_confirmation "foobar"
  end
end