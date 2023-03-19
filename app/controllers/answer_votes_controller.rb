class AnswerVotesController < ApplicationController
  def upvote
    # debugger
    @answer = Answer.find(params[:id].split("/")[0])
    @question = Question.find(params[:id].split("/")[1])
    @user_voted = AnswerVote.find_by(answer_id: @answer.id, user_id: current_user.id)
    if @user_voted
      @user_voted.upvote = 1
      @user_voted.downvote = 0
      @user_voted.save
      flash[:success] = "Answer upvoted"
      redirect_to question_path(@question)
      return
    end

    @answer_vote = AnswerVote.new(user_id: current_user.id, answer_id: @answer.id)
    @answer_vote.upvote = 1;
    if @answer_vote.save
      flash[:success] = "Answer upvoted"
    end
    redirect_to question_path(@question)
  end

  def downvote
    # debugger
    @answer = Answer.find(params[:id])
    @question = Question.find(params[:id])
    @user_voted = AnswerVote.find_by(answer_id: @answer.id, user_id: current_user.id)
    if @user_voted
      @user_voted.downvote = 1
      @user_voted.upvote = 0
      @user_voted.save
      flash[:success] = "Answer downvoted"
      redirect_to question_path(@question)
      return
    end

    @answer_vote = AnswerVote.new(user_id: current_user.id, answer_id: @answer.id)
    @answer_vote.downvote = 1
    if @answer_vote.save
      flash[:success] = "Answer downvoted"
    end
    redirect_to question_path(@question)
  end

end
