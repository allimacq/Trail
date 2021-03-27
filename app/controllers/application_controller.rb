require './config/environment'
class ApplicationController < Sinatra::Base

    configure do
        set :public_folder, 'public'
        set :views, 'app/views'
        #enable :sessions
        #set :session_secret, "need to figure out how to not manually set this"
    end

    get "/" do
        "hello world"
    end

end