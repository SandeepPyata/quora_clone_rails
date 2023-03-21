class AnswersController < ApplicationController
  before_action :logged_in_user, only: [:create, :edit, :update]
  before_action :redirect_if_not_valid_answer_creator, only: [:edit, :update]
  before_action :set_answer, only: [:edit, :update]
  before_action :set_question, only: [:create]

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user_id = current_user.id

    if @answer.save
      flash[:success] = "Answer posted!"
      redirect_to question_path(@question)
    else
      if @answer.content==""
        flash[:danger] = "Empty answer cannot be posted!"
      else
        flash[:danger] = "Answer not posted! Try again"
      end
      @answers = @question.answers.paginate(page: params[:page],per_page: 5)
      redirect_to question_path(@question)
    end
  end

  def update
    if @answer.update(answer_params)
      flash[:success] = "Answer updated!"
      redirect_to question_path(@answer.question)
    else
      flash[:danger] = "Answer not updated! Try again..."
      render 'edit'
    end
  end
  def upvote
    # debugger
    @answer = Answer.find(params[:id])
    @user_voted = AnswerVote.find_by(answer_id: @answer.id, user_id: current_user.id)
    if @user_voted
      @user_voted.upvote = 1
      @user_voted.downvote = 0
      @user_voted.save
      flash[:success] = "Answer upvoted"
      redirect_to question_path(@answer.question_id)
      return
    end

    @answer_vote = AnswerVote.new(user_id: current_user.id, answer_id: @answer.id)
    @answer_vote.upvote = 1;
    if @answer_vote.save
      flash[:success] = "Answer upvoted"
    end
    redirect_to question_path(@answer.question_id)
  end

  def downvote
    # debugger
    @answer = Answer.find(params[:id])
    @user_voted = AnswerVote.find_by(answer_id: @answer.id, user_id: current_user.id)
    if @user_voted
      @user_voted.downvote = 1
      @user_voted.upvote = 0
      @user_voted.save
      flash[:success] = "Answer downvoted"
      redirect_to question_path(@answer.question_id)
      return
    end

    @answer_vote = AnswerVote.new(user_id: current_user.id, answer_id: @answer.id)
    @answer_vote.downvote = 1
    if @answer_vote.save
      flash[:success] = "Answer downvoted"
    end
    redirect_to question_path(@answer.question_id)
  end

  private
  def answer_params
    params.require(:answer).permit(:content)
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:answer][:question_id])
  end

  def redirect_if_not_valid_answer_creator
    @answer = Answer.find(params[:id])
    if @answer.user != current_user
      redirect_to(question_path(@answer.question))
    end
  end
end
