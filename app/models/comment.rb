class Comment < ProjectActivity
  validates :content, presence: true

  belongs_to :updated_by, class_name: :User
end
