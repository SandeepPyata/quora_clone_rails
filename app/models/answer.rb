class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question
  default_scope -> { order(created_at: :desc) }
  validates :content, presence: true, length: { maximum: 140 }
  has_many :answer_votes

  def self.answer_upvote(answer, current_user)
    # Check if user voted to question by fetching record (if exists)
    user_voted =
      AnswerVote.find_by(answer_id: answer.id, user_id: current_user.id)
    message = ""
    if user_voted
      if user_voted.upvote?
        message = "Answer already upvoted"
      else
        user_voted.upvote += 1
        user_voted.downvote -= 1 # as user already downvoted & user wants to upvote; so, change downvote to 0
        user_voted.save
        message = "Previously downvoted; Now upvoted"
      end
    else
      answer_vote =
        AnswerVote.new(user_id: current_user.id, answer_id: answer.id)
      answer_vote.upvote += 1
      if answer_vote.save
        message = "Answer upvoted"
      else
        message = "Answer not upvoted, try again!"
      end
    end
    return message
  end

  def self.answer_downvote(answer, current_user)
    # Check if user voted to answer by fetching record (if exists)
    user_voted =
      AnswerVote.find_by(answer_id: answer.id, user_id: current_user.id)
    message = ""
    if user_voted
      if user_voted.downvote?
        message = "Answer already downvoted"
      else
        user_voted.downvote += 1
        user_voted.upvote -= 1 # as user already upvoted & user wants to downvote; so, change upvote to 0
        user_voted.save
        message = "Previously upvoted; Now downvoted"
      end
    else
      answer_vote =
        AnswerVote.new(user_id: current_user.id, answer_id: answer.id)
      answer_vote.downvote += 1
      if answer_vote.save
        message = "Answer downvoted"
      else
        message = "Answer not downvoted, try again!"
      end
    end
    return message
  end
end
