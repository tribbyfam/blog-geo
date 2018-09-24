require 'sinatra/activerecord'
require 'pg'

set :database, 'postgresql:blogs_data'

class User < ActiveRecord::Base
  has_many :posts, dependent: :destroy
  has_many :comments
end
class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments
end
class Comment < ActiveRecord::Base
  belongs_to :user
  has_one :post
end
class Tag < ActiveRecord::Base
  belongs_to :user
  has_one :post
end
