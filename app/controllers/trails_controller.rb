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
        #user must be logged in to create new trail.
        #if session[:user_id]
            erb :'/trails/new'
        #else
            #flash message that user must be logged in to create new trails and redirect to login page
            #erb :'/users/login'
        #end
    end

    get '/trails/:name' do
        @trail = Trail.find_by_slug(params[:name])
        @user = User.find_by_id(@trail.user_id)
        erb :'/trails/show'
    end

    get "/trails/:name/edit" do
        erb :'/trails/edit'
    end


    post "/trails/new" do
        if params[:trail].empty? == false
            @trail = Trail.create(params[:trail])
            @trail.user_id = 
            @state = State.find_by_id(@trail.state_id.to_i)
            @state.trails << @trail
            @state.save
            flash[:message] = "Trail successfully added! Thank you for your contribution!"
            redirect "/trails/#{@trail.slug}"
        else
            flash[:message] = "Error. Please try again."
            redirect "/"
        end

    end

    patch "/trails/:name" do
        @trail = Trail.find_by_slug(params[:trail])
        #need to make sure params aren't empty!
        #then redirect to individual trail page
        #if not flash error message and redirect to edit again
    end


end
