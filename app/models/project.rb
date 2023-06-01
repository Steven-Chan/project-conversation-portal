class Project < ApplicationRecord
  validates :name, presence: true

  enum status: [:pending, :wip, :done]

  has_many :comments, dependent: :destroy
  belongs_to :created_by, class_name: :User
  belongs_to :updated_by, class_name: :User
end
