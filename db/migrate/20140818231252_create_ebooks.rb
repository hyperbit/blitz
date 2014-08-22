class CreateEbooks < ActiveRecord::Migration
  def change
    create_table :ebooks do |t|
      t.string :title
      t.string :attachment

	  # this line adds an integer column called `article_id`.
      t.references :user, index: true

      t.timestamps
    end
  end
end
