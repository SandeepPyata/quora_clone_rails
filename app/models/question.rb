class Question < ApplicationRecord
  belongs_to :user, class_name: "User"
  default_scope -> { order(created_at: :desc) }
  validates :content, presence: true, length: { maximum: 140 }
  has_many :answers
  has_many :question_votes

  def upvote(current_user)
    """
    # checking if there is a vote for user
    # if there is a previous vote, check for upvote or downvote
    # if previous vote is upvote - no change
    # if previous vote is downvote - toggle upvote and downvote
    """
    user_vote = self.question_votes.where(user: current_user).first()

    if self.upvoted?(current_user)
      # do nothing
      return
    elsif self.downvoted?(current_user)
      user_vote.downvote = false
      user_vote.upvote = true
    else
      user_vote.upvote = true
    end

    user_vote.save()
  end

  def downvote(current_user)
    user_vote = self.question_votes.where(user: current_user).first()

    if self.downvoted?(current_user)
      # do nothing
      return
    elsif self.upvoted?(current_user)
      user_vote.upvote = false
      user_vote.downvote = true
    else
      user_vote.downvote = true
    end

    user_vote.save()
  end

  def upvoted?(current_user)
    user_vote = self.question_votes.where(user: current_user).first()
    user_vote.upvote?
  end

  def downvoted?(current_user)
    user_vote = self.question_votes.where(user: current_user).first()
    user_vote.downvote?
  end

  def upvotes
    self.question_votes.where(upvote:true).size
  end

  def downvotes
    self.question_votes.where(downvote: true).size
  end


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
        if user_voted.save
          message = "Previously downvoted; Now upvoted"
        else
          message = "Question not upvoted, try again!"
        end
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
        if question_vote.save
          message = "Previously upvoted; Now downvoted"
        else
          message = "Question not downvoted, try again!"
        end
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
