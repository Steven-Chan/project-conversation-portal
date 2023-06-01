FactoryBot.define do
  factory :project do
    name { 'Example' }
    description { 'A brief description of this project.' }
    status { :pending }
  end
end
