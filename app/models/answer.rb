class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question
  default_scope -> { order(created_at: :desc) }
  validates :content, presence: true, length: { maximum: 140 }
  # has_many: :answer_votes
end
