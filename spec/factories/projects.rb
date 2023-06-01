# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    name { 'Example' }
    description { 'A brief description of this project.' }
    status { :pending }

    association :created_by, factory: :user
    association :updated_by, factory: :user
  end
end
