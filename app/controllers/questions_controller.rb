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
    if @question.present?
      @answer.question = @question
      @answers = @question.answers.paginate(page: params[:page],per_page: 5)
    end
  end

  def upvote
    # debugger
    @question = Question.find(params[:id])
    @user_voted = QuestionVote.find_by(question_id: @question.id, user_id: current_user.id)
    if @user_voted
      @user_voted.upvote = 1
      @user_voted.downvote = 0
      @user_voted.save
      flash[:notice] = "Question upvoted"
    else
      @question_vote = QuestionVote.new(user_id: current_user.id, question_id: @question.id)
      @question_vote.upvote = 1
      if @question_vote.save
        flash[:success] = "Question has been upvoted"
      end
    end
    redirect_to question_path(@question)
  end

  def downvote
    @question = Question.find(params[:id])
    @user_voted = QuestionVote.find_by(question_id: @question.id, user_id: current_user.id)
    if @user_voted
      @user_voted.downvote = 1
      @user_voted.upvote = 0
      @user_voted.save
      flash[:notice] = "Question downvoted"
    else
      @question_vote = QuestionVote.new(user_id: current_user.id, question_id: @question.id)
      @question_vote.downvote = 1
      if @question_vote.save
        flash[:success] = "Question has been downvoted"
      end
    end
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
    @question = Question.find(params[:id])
    if @question.user != current_user
      redirect_to question_path(@current_question)
    end
  end

end
