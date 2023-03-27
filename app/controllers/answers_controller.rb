class AnswersController < ApplicationController
  before_action :logged_in_user, only: %i[create edit update]
  before_action :redirect_if_not_valid_answer_creator, only: %i[edit update]
  before_action :set_answer, only: %i[edit update upvote downvote]
  before_action :set_question, only: [:create]

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user_id = current_user.id

    if @answer.save
      flash[:success] = "Answer posted!"
      redirect_to question_path(@question)
    else
      if @answer.content == ""
        flash[:danger] = "Empty answer cannot be posted!"
      else
        flash[:danger] = "Answer not posted! Try again"
      end
      @answers = @question.answers.paginate(page: params[:page], per_page: 5)
      redirect_to question_path(@question)
    end
  end

  def update
    if @answer.update(answer_params)
      flash[:success] = "Answer updated!"
      redirect_to question_path(@answer.question)
    else
      flash[:danger] = "Answer not updated! Try again..."
      render "edit"
    end
  end

  def upvote
    @answer.upvote(current_user)
    flash[:notice] = "Upvoted"
    redirect_to question_path(Question.find_by(id: @answer.question_id))
  end

  def downvote
    @answer.downvote(current_user)
    flash[:notice] = "Downvoted"
    redirect_to question_path(Question.find_by(id: @answer.question_id))
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
    redirect_to(question_path(@answer.question)) if @answer.user != current_user
  end
end
