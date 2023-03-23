class Question < ApplicationRecord
  belongs_to :user, class_name: 'User'
  default_scope -> { order(created_at: :desc) }
  validates :content, presence: true, length: { maximum: 140 }
  has_many :answers
  has_many :question_votes

  def self.question_upvote(question, current_user)
    # Check if user voted to question by fetching record (if exists)
    user_voted = QuestionVote.find_by(question_id: question.id, user_id: current_user.id)
    message = ""
    if user_voted
      if user_voted.upvote?
        message = "Question already upvoted"
      else
        user_voted.upvote = 1
        user_voted.downvote = 0      # as user already downvoted & user wants to upvote; so, change downvote to 0
        user_voted.save
        message = "Previously downvoted; Now upvoted"
      end
    else
      question_vote = QuestionVote.new(user_id: current_user.id, question_id: question.id)
      question_vote.upvote = 1
      if question_vote.save
        message = "Question upvoted"
      else
        message = "Question not upvoted, try again!"
      end
    end

    # Fetch total upvotes,downvotes
    @question_upvotes, @question_downvotes = fetch_question_total_upvotes_downvotes(question.id)
    return [@question_upvotes, @question_upvotes, message]
  end

  def self.question_downvote(question, current_user)
    # Check if user voted to question by fetching record (if exists)
    user_voted = QuestionVote.find_by(question_id: question.id, user_id: current_user.id)
    message = ""
    if user_voted
      if user_voted.downvote?
        message = "Question already downvoted"
      else
        user_voted.downvote = 1
        user_voted.upvote = 0     # as user already upvoted & user wants to downvote; so, change upvote to 0
        user_voted.save
        message = "Previously upvoted; Now downvoted"
      end
    else
      question_vote = QuestionVote.new(user_id: current_user.id, question_id: @question.id)
      question_vote.downvote = 1
      if question_vote.save
        message = "Question downvoted"
      else
        message = "Question not downvoted, try again!"
      end
    end

    # Fetch total upvotes,downvotes
    @question_upvotes, @question_downvotes = fetch_question_total_upvotes_downvotes(question.id)
    return [@question_upvotes, @question_upvotes, message]
  end

  private

    def self.fetch_question_total_upvotes_downvotes(id)
      question_votes = QuestionVote.where(question_id: id)
      if question_votes.nil?
        return [0,0]
      else
        upvotes = question_votes.sum(:upvote)
        downvotes = question_votes.sum(:downvote)
        return [upvotes, downvotes]
      end
    end

end
