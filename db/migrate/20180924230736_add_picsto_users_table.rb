class AddPicstoUsersTable < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :pics, :string
  end
end
