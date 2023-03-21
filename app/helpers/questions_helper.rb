module QuestionsHelper
  # TODO: move to model
  def question_votes(question_id)
    return QuestionVote.where(question_id: question_id).sum(:upvote) - (QuestionVote.where(question_id: question_id).sum(:downvote))
  end

  # TODO: move to model
  def answer_votes(answer_id)
    return (AnswerVote.where(answer_id: answer_id).sum(:upvote) - AnswerVote.where(answer_id: answer_id).sum(:downvote))
  end
end
