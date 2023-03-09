class Question < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :question, length: { maximum: 140 }
end
