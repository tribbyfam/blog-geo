class CreateUsersTable < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |table|
      table.string :first_name
      table.string :last_name
      table.string :username
      table.string :email
      table.string :userpassword
      table.date :birthday
      table.timestamps
    end
  end
end
