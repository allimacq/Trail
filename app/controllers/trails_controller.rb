require 'sinatra/base'
#require 'rack-flash'
require './config/environment'

class TrailsController < ApplicationController
    #use Rack::Flash

    get '/trails' do
        @states = State.all
        @trails = Trail.all
        erb :'/trails/index'
    end

    get '/trails/:state' do
        @state = State.find_by_slug(params[:state])
        erb :'/trails/show'
    end

    get "/trails/new" do
        #user must be logged in to create new trail.
        if session[:user_id]
            erb :'/trails/new'
        else
            #flash message that user must be logged in to create new trails and redirect to login page
            erb :'/users/login'
        end
    end

    post "/trails/new" do
        
    end

end
