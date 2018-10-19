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

def logged_in
  !session[:user_id].nil?
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

get '/login/?' do
  if logged_in then
    redirect '/my_post'
  else
  erb :login
  end
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

get '/logout' do
  session[:user_id] = nil

  redirect '/dashboard'
end

get '/users/?' do
  erb :users, locals: { users: User.includes(:posts).all }
end

get '/users/:id' do
  @specific_user = User.find(params[:id])
  @users_posts = @specific_user.posts
  erb :speicific_user
end

get '/posts/?' do
  if (session[:user_id].nil?)
    redirect '/login'
  else
    @current_user = current_user
    @posts = Post.all
   
    # @post = Post.find_by(user_id: @current_user.id)
  end
  erb :posts, locals: { posts: Post.includes(:user, :comments) }
end

get '/posts/:id' do
  post = Post.find_by(title: params[:title])
  erb :posts, locals: { posts: Post.all }
end

get '/my_posts' do
 
  if (session[:user_id].nil?)
    redirect '/login'
  else
    @user = User.find(session[:user_id])
    @posts = Post.where(user_id: session[:user_id])
    # @user = session[:id]
    erb :my_posts
  end
end

get '/new_post' do
  if (session[:user_id].nil?)
    redirect '/login'
  else
    @current_user = current_user
  end
  erb :new_post, locals: { post: {}, new: true }
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
  @post_id = params[:post_id]
  @post_id.destroy
  # redirect '/my_posts'
end

get '/comments' do
  erb :comments
end

get '/new_comment' do
  @post_id = params[:post_id]
  erb :new_comment
end

post '/new_comment' do
  if (session[:user_id].nil?)
    redirect '/login'
  else
    @user = session[:id]
    @specific_post = Post.find_by(:post_id)
    # @specific_user = User.where(user_id: session[:user_id])
    # @user_pic = @specific_user.pics
    @comment = @user.post.comment.create(
    content: params[:content],
    user_id: session[:user_id],
    post_id: params[:post_id],
    created_at: params[:created_at]
  )
  redirect '/comments'
  end
end

get '/dashboard' do
  erb :dashboard
end

get '/delete_user' do
  @current_user = current_user
  @current_user.destroy
  redirect '/dashboard'
end

get '/delete_comment' do
  @current_user = current_user
  @current_comment = Comment.comment_id
  if @current_user == @current_comment.user_id
    @current_comment.destroy
    redirect '/dashboard'
  else
    flash "you can only delete your own comments"
  end

  get '/profile/:id' do
    erb :profile
  end
end


