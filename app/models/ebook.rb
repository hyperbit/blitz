class Ebook < ActiveRecord::Base
	mount_uploader :attachment, AttachmentUploader
	validates :title, presence: true
end
