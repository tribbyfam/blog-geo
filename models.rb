require 'sinatra/activerecord'
require 'pg'

configure :development do
  set :database, 'postgresql:blogs_data'
end

configure :production do
  set :database, ENV["DATABASE_URL"]
end

class User < ActiveRecord::Base
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  # has_many :comments, :through => :posts
end

class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments
end

class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
end

