# class QuestionVotesController < ApplicationController

#   def upvote
#     # debugger
#     @question = Question.find(params[:id])
#     question_vote = QuestionVote.find_by(question_id: @question.id, user_id: current_user.id)
#     if question_vote
#       question_vote.upvote = 1
#       question_vote.downvote = 0
#       question_vote.save
#       flash[:notice] = "Question upvoted"
#       redirect_to question_path(@question)
#     else

#     end

#     question_vote = QuestionVote.new(user_id: current_user.id, question_id: @question.id)
#     question_vote.upvote = 1
#     if @question_vote.save
#       flash[:success] = "Question has been upvoted"
#     end
#     redirect_to question_path(@question)
#   end

#   def downvote
#     @question = Question.find(params[:id])
#     @user_voted = QuestionVote.find_by(question_id: @question.id, user_id: current_user.id)
#     if @user_voted
#       @user_voted.downvote = 1
#       @user_voted.upvote = 0
#       @user_voted.save
#       flash[:notice] = "Question downvoted"
#       redirect_to question_path(@question)
#       return
#     end

#     @question_vote = QuestionVote.new(user_id: current_user.id, question_id: @question.id)
#     @question_vote.downvote = 1
#     if @question_vote.save
#       flash[:success] = "Question has been downvoted"
#     end
#     redirect_to question_path(@question)
#   end
# end
