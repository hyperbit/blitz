class AddReferencesToEbooks < ActiveRecord::Migration
  def change
    add_reference :ebooks, :user, index: true
  end
end
