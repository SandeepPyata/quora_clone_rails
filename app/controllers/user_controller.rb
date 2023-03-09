class UserController < ApplicationController
  # before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  # before_action :correct_user,   only: [:edit, :update]


  # def new
  #   @user = User.new
  # end

  # def create
  #   @user = User.new(user_params)
  #   if @user.save
  #     log_in @user
  #     flash[:success] = "Welcome to the Sample App!"
  #     redirect_to @user
  #   else
  #     render 'new'
  #   end
  # end

  # private
  # Confirms a logged-in user.
  # def logged_in_user
  #   unless signed_in?
  #     store_location
  #     flash[:danger] = "Please log in."
  #     redirect_to sign_in_url
  #   end
  # end

  # def correct_user
  #   @user = User.find(params[:id])
  #   redirect_to(root_url) unless current_user?(@user)
  # end
end
