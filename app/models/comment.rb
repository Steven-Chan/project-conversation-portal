class Comment < ApplicationRecord
  validates :content, presence: true

  belongs_to :project
  belongs_to :created_by, class_name: :User
  belongs_to :updated_by, class_name: :User
end
