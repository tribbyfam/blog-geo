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
  erb :posts, locals: { posts: Post.all }
end

get '/users' do
  erb :users, locals: { users: User.all }
end

get '/comments' do
  erb :comments, locals: { comments: Comment.all }
end

get '/dashboard' do
  erb :dashboard, { locals: {}, layout: :dash_layout}
end

get '/logout' do
  session[:user_id] = nil

  redirect '/'
end
