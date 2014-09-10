class AddListIdColumnToEbooks < ActiveRecord::Migration
  def change
    add_column :ebooks, :bookmark, :integer
  end
end
