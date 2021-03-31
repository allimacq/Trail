require './config/environment'
require 'sinatra/base'
require 'rack-flash'
class ApplicationController < Sinatra::Base

    configure do
        set :public_folder, 'public'
        set :views, 'app/views'
        enable :sessions
        use Rack::Flash
        #set :session_secret, "need to figure out how to not manually set this"
    end

    get "/" do
        @states = State.all
        erb :index
    end

end