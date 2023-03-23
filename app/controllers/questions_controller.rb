class QuestionsController < ApplicationController
  before_action :logged_in_user, only: [:create]
  before_action :redirect_if_not_valid_question_creator, only: [:edit, :update]
  before_action :set_question, only: [:edit, :update, :show, :upvote, :downvote]

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
      flash[:success] = "Question posted!"
    else
      if @question.content==""
        flash[:danger] = "Empty question cannot be posted!"
      else
        flash[:danger] = "Question not posted! Try again"
      end
      @all_feed_items = Question.paginate(page: params[:page], per_page: 5)
    end
    redirect_to root_url
  end

  def update
    if @question.update(question_params)
      flash[:success] = "Question updated!"
    else
      flash[:danger] = "Question not updated! Try again..."
    end
    redirect_to question_path(@question)
  end

  def user_questions
    @feed_items = current_user.feed.paginate(page: params[:page], per_page: 5)
  end

  def show
    @answer = current_user.answers.build()
    @question_upvotes = 0
    @question_downvotes = 0

    if @question.present?
      # Fetch total upvotes,downvotes
      @question_upvotes, @question_downvotes = fetch_question_total_upvotes_downvotes(@question.id)
      @answer.question = @question
      @answers = @question.answers.paginate(page: params[:page],per_page: 5)
    end
  end

  def upvote
    @question_upvotes, @question_downvotes, message = Question.question_upvote(@question, current_user)
    flash[:notice] = message
    redirect_to question_path(@question)
  end

  def downvote
    @question_upvotes, @question_downvotes, message = Question.question_downvote(@question, current_user)
    flash[:notice] = message
    redirect_to question_path(@question)
  end

  private
  def question_params
    params.require(:question).permit(:content)
  end

  def set_question
    if Question.find_by_id(params[:id])
      @question = Question.find(params[:id])
    end
  end

  def redirect_if_not_valid_question_creator
    question = Question.find(params[:id])
    if question.user != current_user
      redirect_to question_path(question)
    end
  end

  def fetch_question_total_upvotes_downvotes(id)
    question_votes = QuestionVote.where(question_id: id)
    if question_votes.nil?
      return [0,0]
    else
      upvotes = question_votes.sum(:upvote)
      downvotes = question_votes.sum(:downvote)
      return [upvotes, downvotes]
    end
  end

end
