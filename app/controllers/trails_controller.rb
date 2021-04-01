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
            #flash message that user must be logged in to create new trails and redirect to login page
            redirect "/login"
        end
    end

    get '/trails/:id' do
        @trail = Trail.find_by_id(params[:id])
        @user = User.find_by_id(@trail.user_id)
        erb :'/trails/show'
    end

    get "/trails/:id/edit" do
        @trail = Trail.find_by_id(params[:id])
        if session[:user_id] == @trail.user_id
            erb :'/trails/edit'
        else
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
            redirect "/trails/#{@trail.slug}"
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
        else
            @trail = Trail.find_by_id(params[:id])
            @state = State.find_by_id(@trail.id)
            @trail.surface = []
            @trail.update(name: params[:trail][:name], )
            @state.trails << @trail
            end
        #if the name HAS been changed
        else
            @delete = Trail.find_by(name: params[:trail][:name])
            @delete.destroy
            


        #need to make sure params aren't empty!
        #then redirect to individual trail page
        #if not flash error message and redirect to edit again
    end


end
