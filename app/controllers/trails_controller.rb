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

end
