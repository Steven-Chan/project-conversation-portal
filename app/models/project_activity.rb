class ProjectActivity < ApplicationRecord
  belongs_to :project
  belongs_to :created_by, class_name: :User
end
