module CurrentUser

    def user(session)
        @user = User.find_by_id(session[:user_id])
    end
      
    def logged_in?(session)
        !!self.user(session)
    end
end
