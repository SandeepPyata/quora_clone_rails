class QuestionVote < ApplicationRecord
  belongs_to :question
  belongs_to :user
end
