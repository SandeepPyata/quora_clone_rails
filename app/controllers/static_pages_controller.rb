class StaticPagesController < ApplicationController
  def index
    if user_signed_in?
      @question = current_user.questions.build
      @feed_items = current_user.feed.paginate(page: params[:page], per_page: 10)
    end
  end
end
