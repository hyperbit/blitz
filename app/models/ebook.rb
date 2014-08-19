class Ebook < ActiveRecord::Base
	mount_uploader :attachment, AttachmentUploader
	has_many :pages
	validates :title, presence: true
end
