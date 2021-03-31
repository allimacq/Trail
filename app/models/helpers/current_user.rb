module CurrentUser

    def current_user(session)
        @user = User.find_by_id(session[:user_id])
    end
      
    def logged_in?(session)
        !!self.current_user(session)
    end
end
