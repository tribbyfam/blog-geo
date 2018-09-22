class CreateCommentsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |table|
      table.string :content
      table.references :user
      table.references :post
      table.references :tag
      table.timestamps
    end
  end
end
