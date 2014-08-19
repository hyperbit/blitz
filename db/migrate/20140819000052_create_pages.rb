class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.text :content
			# this line adds an integer column called `article_id`.
      t.references :ebook, index: true

      t.timestamps
    end
  end
end
