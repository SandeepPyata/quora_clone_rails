class Question < ApplicationRecord
  belongs_to :user, class_name: "User"
  default_scope -> { order(created_at: :desc) }
  validates :content, presence: true, length: { maximum: 140 }
  has_many :answers
  has_many :question_votes

  def self.question_upvote(question, current_user)
    # Check if user voted to question by fetching record (if exists)
    user_voted =
      QuestionVote.find_by(question_id: question.id, user_id: current_user.id)
    message = ""
    if user_voted
      if user_voted.upvote?
        message = "Question already upvoted"
      else
        user_voted.upvote += 1
        user_voted.downvote -= 1
        user_voted.save
        message = "Previously downvoted; Now upvoted"
      end
    else
      question_vote =
        QuestionVote.new(user_id: current_user.id, question_id: question.id)
      question_vote.upvote += 1
      if question_vote.save
        message = "Question upvoted"
      else
        message = "Question not upvoted, try again!"
      end
    end

    return message
  end

  def self.question_downvote(question, current_user)
    # Check if user voted to question by fetching record (if exists)
    user_voted =
      QuestionVote.find_by(question_id: question.id, user_id: current_user.id)
    message = ""
    if user_voted
      if user_voted.downvote?
        message = "Question already downvoted"
      else
        user_voted.downvote += 1
        user_voted.upvote -= 1
        user_voted.save
        message = "Previously upvoted; Now downvoted"
      end
    else
      question_vote =
        QuestionVote.new(user_id: current_user.id, question_id: @question.id)
      question_vote.downvote += 1
      if question_vote.save
        message = "Question downvoted"
      else
        message = "Question not downvoted, try again!"
      end
    end

    return message
  end
end
