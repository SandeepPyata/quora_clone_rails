class AnswersController < ApplicationController
  before_action :logged_in_user, only: [:create, :edit, :update]
  before_action :correct_user, only: [:create, :edit, :update]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.user_id = current_user.id
    byebug

    if @question.answers.where(user_id: current_user.id).exists?
      flash[:alert] = "You have already answered this question"
      redirect_to question_path(@question)
      return
    end

    if @answer.save
      flash[:success] = "Answer created!"
      redirect_to question_path(@question)
    else
      flash[:danger] = "Answer not created!"
      @answers = @question.answers.paginate(page: params[:page],per_page: 5)
      redirect_to question_path(@question)
    end
  end

  def edit
    # byebug
    @answer = Answer.find(params[:id])
  end

  def update
    @answer = Answer.find(params[:id])
    if @answer.update(answer_params)
      byebug
      flash[:success] = "Answer updated!"
      redirect_to answer_path(@answer)
    else
      flash[:danger] = "Answer not updated! Try again..."
      render 'edit'
    end
  end

  def show
    # byebug
    @answer = Answer.find(params[:id])
    @question = @answer.question
    @answers = @question.answers.paginate(page: params[:page])
    render 'questions/show'
  end

  def correct_user
    @current_answer = current_user.answers.find_by(params[:id])
    redirect_to(question_path) if @current_answer.nil?
  end

  private
  def answer_params
    byebug
    params.require(:answer).permit(:content)
    byebug
  end

end
