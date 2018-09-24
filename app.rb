require 'sinatra'
require_relative 'models'

enable :sessions

# set :sessions, true
# use Rack::MethodOverride

def current_user
  User.find(session[:user_id])
end

def current_user_name
  User.find_by(session[:user_id], first_name: params[:first_name])
end

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
  redirect '/new_post'
end

get '/login' do
  erb :login
end

post '/login' do
  user = User.find_by(email: params[:email])

  if user && user.userpassword == params[:userpassword]
    session[:user_id] = user.id
    redirect '/my_posts'
  else
    redirect '/signup'
  end
end

get '/users' do
  erb :users, locals: { users: User.all }
end

get '/users/:id' do
  @users = User.all
  @users_posts = @users.posts
  erb :my_posts
end

get '/posts' do
  if (session[:user_id].nil?)
    redirect '/login'
  else
    @current_user = current_user
    @posts = Post.all
    # @post = Post.find_by(user_id: @current_user.id)
  end
  erb :posts
end

get '/posts/:id' do
  post = Post.find_by(title: params[:title ])
  erb :posts, locals: { posts: Post.all }
end

get '/my_posts' do
 
  if (session[:user_id].nil?)
    redirect '/login'
  else
    @user = User.find(session[:user_id])
    @post = Post.where(user_id: session[:user_id])
    @user = session[:id]
    erb :my_posts
  end
end

get '/new_post' do
  if (session[:user_id].nil?)
    redirect '/login'
  else
    @current_user = current_user
  end
  erb :new_post
end

post '/new_post' do
  if (session[:user_id].nil?)
    redirect '/login'
  else
  @user = session[:id]
  @posts = Post.create(
    title: params[:title],
    content: params[:content],
    user_id: session[:user_id]
    )
    redirect '/posts'
  end
end

get '/posts/:id/edit' do
  user = User.find_by(params[:id])
  erb :edit_post
end

put '/posts/:id' do
  user = User.find_by(params[:id])
  @user_posts = user.post
  # @user.update(title: params[:title], content: params[:content])
end

delete '/posts/:id' do
  @post = Post.find_by(params[:id])
  @post.destroy
  redirect '/posts'
end

get '/comments' do
  erb :comments, locals: { comments: Comment.all }
end

get '/dashboard' do
  erb :dashboard, { locals: {}, layout: :dash_layout}
end

get '/logout' do
  session[:user_id] = nil

  redirect '/dashboard'
end

def delete_user
  # @current_user = User.find(session[:user_id])
  # @current_user = destroy
  # redirect '/users'
end



