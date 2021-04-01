require 'sinatra/base'
require 'rack-flash'
require './config/environment'

class TrailsController < ApplicationController
    use Rack::Flash

    get '/states/:state' do
        @state = State.find_by_slug(params[:state])
        erb :'/trails/index'
    end

    get "/trails/new" do
        if User.logged_in?(session) == true
            @user = User.user(session)
            erb :'/trails/new'
        else
            flash[:message] = "You must be logged in to add a trail."
            redirect "/login"
        end
    end

    get '/trails/:id' do
        @trail = Trail.find_by_id(params[:id])
        #@user = User.find_by_id(@trail.user_id)
        erb :'/trails/show'
    end

    get "/trails/:id/edit" do
        @trail = Trail.find_by_id(params[:id])
        if session[:user_id] && session[:user_id] == @trail.user_id
            erb :'/trails/edit'
        else
            flash[:message] = "You can only edit trails you've made."
            redirect "/"
        end
    end

    get '/trails/:id/delete' do
        @trail = Trail.find_by_id(params[:id])
        if session[:user_id] && session[:user_id] == @trail.user_id
            erb :'/trails/delete'
        else
            flash[:message] = "You can only delete your own trails."
            redirect "/"
        end
    end

    post "/trails/new" do
        if params[:trail].empty? == false
            @user = User.user(session)
            @trail = Trail.create(params[:trail])
            @state = State.find_by_id(@trail.state_id.to_i)
            @state.trails << @trail
            @state.save
            @user.trails << @trail
            flash[:message] = "Trail successfully added! Thank you for your contribution!"
            redirect "/trails/#{@trail.id}"
        else
            flash[:message] = "Error. Please try again."
            redirect "/"
        end

    end

    patch "/trails/:id" do
        #making sure nothing is empty
        if params[:trail].empty?
            #retun error if empty
            flash[:message] = "Error. Please try again."
            redirect "/trails/#{params[:id].to_i}/edit"
        else
            @user = User.user(session)
            @trail = Trail.find_by_id(params[:id])
            @state = State.find_by_id(params[:trail][:state_id])
            @trail.surface = []
            @trail.update(name: params[:trail][:name], info: params[:trail][:info], distance: params[:trail][:distance], surface: params[:trail][:surface])
            @state.trails << @trail
            @user.trails << @trail
            redirect "/trails/#{@trail.id}"
        end
    end

    delete "/trails/:id/delete" do
        @trail = Trail.find_by_id(params[:id])
        @trail.delete
        redirect "/users/#{session[:user_id]}"
    end



end
