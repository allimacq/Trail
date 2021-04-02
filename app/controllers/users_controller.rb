class UsersController < ApplicationController

    get '/signup' do
        if session[:user_id]
            @user = User.find_by_id(session[:user_id])
            redirect "/users/#{@user.id}"
        else
            erb :'/users/signup'
        end
    end

    post '/signup' do
        #don't want any fields left blank
        if params[:username].empty? || params[:password].empty? || User.find_by(username: params[:username])
            flash[:message] = "Sign up unsuccessful. Please try again."
            redirect "/signup"
        else
            #if both fields aren't empty, then create new user.
            @user = User.create(username: params[:username], password: params[:password])
            session[:user_id] = @user.id
            #redirect to their homepage
            flash[:message] = "Welcome, #{@user.username}!"
            redirect "/users/#{@user.id}"
        end
    end

    get "/login" do
        #logged in users cannot view this. will redirect them to the homepage
        #if User.logged_in?(session)
        if session[:user_id]
            redirect "/users/#{session[:user_id]}"
        else
            erb :"/users/login"
        end
    end

    post "/login" do
        @user = User.find_by(username: params[:username])
        if @user && @user.authenticate(params[:password])
            session[:user_id] = @user.id
            redirect "/users/#{@user.id}" 
        else
            flash[:message] = "Could not log in. Please try again."
            redirect "/login"
        end
    end

    get "/logout" do
        if session[:user_id]
            session.clear
            redirect "/login"
        else
            redirect "/"
        end
    end


    get "/users/:id" do
        #only users can view their homepage
        @user = User.find_by_id((params[:id]).to_i)
        if session[:user_id] == @user.id
            erb :'/users/show'
        else
            redirect '/'
        end
    end


end
