class Ebook < ActiveRecord::Base
	mount_uploader :attachment, AttachmentUploader
	has_many :pages, dependent: :destroy
	validates :title, presence: true

	def self.destroy_ebooks
    dir = "public/uploads/ebooks"
    FileUtils.rm_rf(dir)
    Ebook.delete_all
  end
end
