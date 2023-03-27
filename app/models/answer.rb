class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question
  default_scope -> { order(created_at: :desc) }
  validates :content, presence: true, length: { maximum: 140 }
  has_many :answer_votes

  def upvote(current_user)
    user_vote = self.answer_votes.where(user: current_user).first()

    if self.upvoted?(current_user)
      # do nothing
      return
    elsif self.downvoted?(current_user)
      user_vote.downvote = false
      user_vote.upvote = true
    else
      user_vote = AnswerVote.new(user_id: current_user.id, answer_id: self.id)
      user_vote.upvote = true
    end
    user_vote.save()
  end

  def downvote(current_user)
    user_vote = self.answer_votes.where(user: current_user).first()

    if self.downvoted?(current_user)
      # do nothing
      return
    elsif self.upvoted?(current_user)
      user_vote.upvote = false
      user_vote.downvote = true
    else
      user_vote = AnswerVote.new(user_id: current_user.id, answer_id: self.id)
      user_vote.downvote = true
    end
    user_vote.save()
  end

  def upvoted?(current_user)
    user_vote = self.answer_votes.where(user: current_user).first()
    return user_vote.upvote? if user_vote
    return false
  end

  def downvoted?(current_user)
    user_vote = self.answer_votes.where(user: current_user).first()
    return user_vote.downvote? if user_vote
    return false
  end
end
