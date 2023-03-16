class StaticPagesController < ApplicationController
  def index
    if user_signed_in?
      @question = current_user.questions.build
      @all_feed_items = Question.paginate(page: params[:page], per_page: 5)
    end
  end

  def show
    @question = Question.find(params[:id])
    @answers = @question.answers.paginate(page: params[:page],per_page: 5)
  end

end
