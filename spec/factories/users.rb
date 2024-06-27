FactoryBot.define do
  factory :user do
    first_name { 'John' }
    last_name { 'Doe' }
    email { 'john.doe@gmail.com' }
    password { 'test@123' }
    password_confirmation { 'test@123' }
  end
end
