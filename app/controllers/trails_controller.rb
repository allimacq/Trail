require 'sinatra/base'
#require 'rack-flash'
require './config/environment'

class TrailsController < ApplicationController
    #use Rack::Flash

    get '/trails' do
        @trails = Trail.all
        erb :'/trails/show'
    end

end
