class QuestionController < ApplicationController
  # before_action :logged_in_user, only: [:create, :destroy]

  # def create
  #   @question = current_user.questions.build(question_params)
  #   if @question.save
  #     flash[:success] = "Question created!"
  #     redirect_to root_url
  #   else
  #     render 'homepage/index'
  #   end
  # end
  # private
  #   def question_params
  #       params.require(:question).permit(:question)
  #   end
end
