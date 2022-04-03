require 'sinatra/base'
require 'sinatra/reloader'
require_relative './lib/bookmarks'
require_relative './database_connection_setup.rb'
require 'uri'
require './lib/user'
require 'sinatra/flash'

class BookmarkManager < Sinatra::Base
  
  enable :sessions, :method_override
  
    configure :development do
    register Sinatra::Reloader
    register Sinatra::Flash
  end 

  get '/' do
    'Bookmark Manager'
  end

  get '/bookmarks' do
    @user = User.find(id: session[:user_id])
    @bookmarks = Bookmark.all
    erb :'bookmarks/index'
  end

  get '/bookmarks/new' do
    erb :'bookmarks/new'
  end

  post '/bookmarks' do
    flash[:notice] = "You must submit a valid URL" unless Bookmark.create(
      url: params[:url], title: params[:title]
      )
    redirect('/bookmarks')
  end 

  post '/bookmarks' do
    Bookmark.create(url: params[:url], title: params[:title])
    redirect '/bookmarks'
  end

  delete '/bookmarks/:id' do
    Bookmark.delete(id: params[:id])
    redirect '/bookmarks'
  end

  get '/bookmarks/:id/edit' do
    @bookmark = Bookmark.find(id: params[:id])
    erb :"bookmarks/edit"
  end

  patch '/bookmarks/:id' do
    Bookmark.update(id: params[:id], title: params[:title], url: params[:url])
    redirect('/bookmarks')
  end

  get '/bookmarks/:id/comments/new' do
    @bookmark_id = params[:id]
    erb :"comments/new"
  end 

  post '/bookmarks/:id/comments' do
    Comment.create(bookmark_id: params[:id], text: params[:comment])
    redirect '/bookmarks'
  end

  get '/users/new' do 
    erb :'users/new'
  end 

  post '/users' do
    user = User.create(email: params['email'], password: params['password'])
    session[:user_id] = user.id
    redirect '/bookmarks'
  end 

  run! if app_file == $0
end