class QuestionsController < ApplicationController
  before_action :logged_in_user, only: [:create]
  before_action :correct_user,   only: [:edit, :update]

  def create
    @question = current_user.questions.build(question_params)
    @answers = @question.answers
    @question.user_id = current_user.id
    if @question.save
      flash[:success] = "Question created!"
      redirect_to root_url
    else
      flash[:danger] = "Question not created!"
      @all_feed_items = Question.paginate(page: params[:page], per_page: 5)
      render 'static_pages/index'
    end
  end

  def edit
    @question = Question.find(params[:id])
    @show_question_edit_form = params[:show_question_edit_form].present?
    # byebug
  end

  def update
    @question = Question.find(params[:id])
    if @question.update(question_params)
      flash[:success] = "Question updated!"
      redirect_to question_path(@question)
    else
      flash[:danger] = "Question not updated! Try again..."
      render 'edit'
    end
  end

  def myquestions
    @feed_items = current_user.feed.paginate(page: params[:page], per_page: 5)
  end

  def show
    @question = Question.find(params[:id])
    # @answer = Answer.find_by(question_id: @question.id)
    @answers = @question.answers.paginate(page: params[:page],per_page: 5)
    # byebug
  end

  def correct_user
    @current_question = Question.find(params[:id])
    @question_in_user_questions = current_user.questions.find_by(params[:id])
    redirect_to question_path(@current_question) unless @question_in_user_questions == @current_question
  end

  private
    def question_params
      params.require(:question).permit(:content)
    end


end
