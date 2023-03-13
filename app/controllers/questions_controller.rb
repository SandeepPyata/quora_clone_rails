class QuestionsController < ApplicationController
  before_action :logged_in_user, only: [:create]
  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      flash[:success] = "Question created!"
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/index'
    end
  end

  def userquestions
    @feed_items = current_user.feed.paginate(page: params[:page])
    render 'questions/userquestions'
  end

  private
    def question_params
      params.require(:question).permit(:content)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end

end
