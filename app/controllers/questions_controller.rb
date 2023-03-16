class QuestionsController < ApplicationController
  before_action :logged_in_user, only: [:create]
  before_action :redirect_if_not_valid_question_creator, only: [:edit, :update]
  before_action :set_question, only: [:edit, :update, :show]

  def index
    if user_signed_in?
      @question = current_user.questions.build
      @all_feed_items = Question.paginate(page: params[:page], per_page: 5)
    end
  end

  def create
    @question = current_user.questions.build(question_params)
    @question.user_id = current_user.id
    if @question.save
      flash[:success] = "Question created!"
    else
      flash[:danger] = "Question not created!"
      @all_feed_items = Question.paginate(page: params[:page], per_page: 5)
      render 'index'
    end
    redirect_to root_url
  end

  def update
    if @question.update(question_params)
      flash[:success] = "Question updated!"
    else
      flash[:danger] = "Question not updated! Try again..."
    end
    redirect_to edit_question_path(@question)
  end

  def myquestions
    @feed_items = current_user.feed.paginate(page: params[:page], per_page: 5)
  end

  def show
    @answer = current_user.answers.build()
    @answer.question = @question
    @answers = @question.answers.paginate(page: params[:page],per_page: 5)
  end


  private
  def question_params
    params.require(:question).permit(:content)
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def redirect_if_not_valid_question_creator
    @question = Question.find(params[:id])
    if @question.user != current_user
      redirect_to question_path(@current_question)
    end
  end
end
