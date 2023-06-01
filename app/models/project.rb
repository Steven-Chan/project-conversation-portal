class Project < ApplicationRecord
  enum status: [:pending, :wip, :done]
end
