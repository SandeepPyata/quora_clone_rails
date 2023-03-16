class AnswersController < ApplicationController
  before_action :logged_in_user, only: [:create, :edit, :update]
  before_action :redirect_if_not_valid_answer_creator, only: [:edit, :update]
  before_action :set_answer, only: [:edit, :update]
  before_action :set_question, only: [:create]

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user_id = current_user.id

    #if @question.answers.where(user_id: current_user.id).exists?
      #flash[:alert] = "You have already answered this question"
      #redirect_to question_path(@question)
      #return
    #end

    if @answer.save
      flash[:success] = "Answer created!"
      redirect_to question_path(@question)
    else
      flash[:danger] = "Answer not created!"
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
