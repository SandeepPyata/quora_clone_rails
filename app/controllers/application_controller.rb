class ApplicationController < ActionController::Base
  private
    # Confirms a logged-in user.
    def logged_in_user
        unless logged_in?
            store_location
            flash[:danger] = "Please log in."
            redirect_to new_user_session
        end
    end
    def logged_in?
      !current_user.nil?
    end

    def current_user
      if (user_id = session[:user_id])
          @current_user ||= User.find_by(id: user_id)
      elsif (user_id = cookies.encrypted[:user_id])
          user = User.find_by(id: user_id)
          if user && user.authenticated?(cookies[:remember_token])
              log_in user
              @current_user = user
          end
      end
    end
end
