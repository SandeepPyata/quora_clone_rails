class AnswersController < ApplicationController

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.user_id = current_user.id
    if @answer.save
      flash[:success] = "Answer created!"
      redirect_to @question
    else
      flash[:danger] = "Answer not created!"
      @answers = @question.answers.paginate(page: params[:page],per_page: 5)
      render 'questions/show'
    end
  end

  private
    def answer_params
      params.permit(:content)
    end


end
