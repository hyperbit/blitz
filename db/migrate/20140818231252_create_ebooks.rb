class CreateEbooks < ActiveRecord::Migration
  def change
    create_table :ebooks do |t|
      t.string :title
      t.string :attachment


      t.timestamps
    end
  end
end
