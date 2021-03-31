class UsersController < ApplicationController

    get '/signup' do
        #only want people NOT logged in to view signup page

        #will redirect them to their homepage if they are logged in

        erb :'/users/signup'
    end

    post '/signup' do
        #don't want any fields left blank
        if params[:username].empty? || params[:password].empty?
            redirect "/signup"
        else
            #if both fields aren't empty, then create new user.
            @user = User.create(username: params[:username], password: params[:password])
            session[:user_id] = @user.id
            #redirect to their homepage
            redirect ""
        end
    end

    get "/login" do
        #logged in users cannot view this. will redirect them to their homepage
        if session[:user_id]
            redirect ""
        else
            erb :"/users/login"
        end
    end

    post "/login" do
        @user = User.find_by(username: params[:username])
        if @user && @user.authenticate(params[:password])
            session[:user_id] = @user.id
            redirect "" #redirect to their homepage
        else
            #flash error message
        end
    end
end
