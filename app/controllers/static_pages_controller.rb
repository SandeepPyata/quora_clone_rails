class StaticPagesController < ApplicationController
  def show
    @question = Question.find(params[:id])
    @answers = @question.answers.paginate(page: params[:page],per_page: 5)
  end

end
