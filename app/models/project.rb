class Project < ApplicationRecord
  validates :name, presence: true

  enum status: [:pending, :wip, :done]

  has_many :comments, dependent: :destroy
end
