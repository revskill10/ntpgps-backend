require 'faker'

3.times do |i|
  User.create!(name: Faker::Name.name, email: Faker::Internet.email , password: '123123123' , password_confirmation: '123123123')
end
