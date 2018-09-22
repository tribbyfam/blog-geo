require 'sinatra/activerecord'
require 'pg'

set :database, 'postgresql:blogs_data'

class User < ActiveRecord::Base
end
class Post < ActiveRecord::Base
end
class Comment < ActiveRecord::Base
end
class Tag < ActiveRecord::Base
end
