FactoryBot.define do
  factory :comment do
    content { Faker::Lorem.paragraph(sentence_count: 2) }

    association :created_by, factory: :user
    association :updated_by, factory: :user
  end
end
