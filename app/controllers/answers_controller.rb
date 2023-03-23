class AnswersController < ApplicationController
  before_action :logged_in_user, only: [:create, :edit, :update]
  before_action :redirect_if_not_valid_answer_creator, only: [:edit, :update]
  before_action :set_answer, only: [:edit, :update, :upvote, :downvote]
  before_action :set_question, only: [:create]

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user_id = current_user.id

    if @answer.save
      flash[:success] = "Answer posted!"
      redirect_to question_path(@question)
    else
      if @answer.content==""
        flash[:danger] = "Empty answer cannot be posted!"
      else
        flash[:danger] = "Answer not posted! Try again"
      end
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


  def upvote
    flash[:notice] = Answer.answer_upvote(@answer,current_user)
    redirect_to question_path(Question.find_by(id: @answer.question_id))
  end

  def downvote
    flash[:notice] = Answer.answer_downvote(@answer,current_user)
    redirect_to question_path(Question.find_by(id: @answer.question_id))
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

  # def fetch_answer_total_upvotes_downvotes(answer)
  #   answer_votes = AnswerVote.where(id: answer.id)
  #   if answer_votes.nil?
  #     return [0,0]
  #   else
  #     upvotes = answer_votes.sum(:upvote)
  #     downvotes = answer_votes.sum(:downvote)
  #     return [upvotes, downvotes]
  #   end
  # end
end
