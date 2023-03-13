class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @questions = @user.questions.paginate(page: params[:page], per_page: 10)
  end

  # def index
  #   @users = User.paginate(page: params[:page], per_page: 10)
  # end

  # def edit
  #   @user = User.find(params[:id])
  # end

  # def update
  #   @user = User.find(params[:id])
  #   if @user.update(user_params)
  #     # Handle a successful update
  #     flash[:success] = "Profile updated"
  #     redirect_to @user
  #   else
  #     render 'edit'
  #   end
  # end

  # def destroy
  #   User.find(params[:id]).destroy
  #   flash[:success] = "User deleted"
  #   redirect_to users_url
  # end

  private

    # def user_params
    #   params.require(:user).permit(:name, :email, :password, :password_confirmation)
    # end
    def logged_in_user
      unless user_signed_in?
        flash[:danger] = "Please log in."
        redirect_to user_session_url
      end
    end
end
