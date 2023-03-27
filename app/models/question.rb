class Question < ApplicationRecord
  belongs_to :user, class_name: "User"
  default_scope -> { order(created_at: :desc) }
  validates :content, presence: true, length: { maximum: 140 }
  has_many :answers
  has_many :question_votes

  def upvote(current_user)
    "" \
      "
    # checking if there is a vote for user
    # if there is a previous vote, check for upvote or downvote
    # if previous vote is upvote - no change
    # if previous vote is downvote - toggle upvote and downvote
    " \
      ""
    user_vote = self.question_votes.where(user: current_user).first()

    if self.upvoted?(current_user)
      # do nothing
      return
    elsif self.downvoted?(current_user)
      user_vote.downvote = false
      user_vote.upvote = true
    else
      user_vote =
        QuestionVote.new(user_id: current_user.id, question_id: self.id)
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
      user_vote =
        QuestionVote.new(user_id: current_user.id, question_id: self.id)
      user_vote.downvote = true
    end

    user_vote.save()
  end

  def upvoted?(current_user)
    user_vote = self.question_votes.where(user: current_user).first()
    return user_vote.upvote? if user_vote
    return false
  end

  def downvoted?(current_user)
    user_vote = self.question_votes.where(user: current_user).first()
    return user_vote.downvote? if user_vote
    return false
  end

  def upvotes
    self.question_votes.where(upvote: true).size
  end

  def downvotes
    self.question_votes.where(downvote: true).size
  end
end
