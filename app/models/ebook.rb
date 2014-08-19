class Ebook < ActiveRecord::Base
	mount_uploader :attachment, AttachmentUploader
	has_many :pages, dependent: :destroy
	validates :title, presence: true
end
