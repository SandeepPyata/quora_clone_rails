class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def feed
    Question.all
  end
  private

  def logged_in_user
    unless user_signed_in?
      flash[:danger] = "Please log in."
      redirect_to user_session_url
    end
  end
end
