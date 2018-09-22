require 'sinatra'
require_relative 'models'

set :sessions, true
use Rack::MethodOverride

get '/' do
 
  erb :dashboard
end

get '/signup' do
  erb :signup
end

post '/signup' do
  user = User.create(
  first_name: params[:first_name],
  last_name: params[:last_name],
  username: params[:username],
  email: params[:email],
  userpassword: params[:userpassword],
  birthday: params[:birthdate]
  )
  session[:user_id] = user.id
  redirect '/posts'
end

get '/login' do
  erb :login
end

post '/login' do
  user = User.find_by(email: params[:email])

  if user && user.userpassword == params[:userpassword]
    session[:user_id] = user.id
    redirect '/posts'
  else
    redirect '/signup'
  end
end

get '/posts' do
 
  erb :posts
end

get '/users' do
  'users'
  erb :users
end

get '/comments' do
  'comments'
  erb :comments
end

get '/dashboard' do
  erb :dashboard, { locals: {}, layout: :dash_layout}
end
