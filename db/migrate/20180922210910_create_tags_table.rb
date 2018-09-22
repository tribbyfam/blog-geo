class CreateTagsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |table|
      table.string :content
      table.references :posts
      table.timestamps
    end
  end
end
