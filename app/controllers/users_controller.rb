class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @questions = @user.questions.paginate(page: params[:page], per_page: 5)
  end

  private

end
