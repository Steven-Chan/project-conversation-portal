class Project < ApplicationRecord
  validates :name, presence: true

  enum status: [:pending, :wip, :done]
end
