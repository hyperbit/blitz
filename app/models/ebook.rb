class Ebook < ActiveRecord::Base
	mount_uploader :attachment, AttachmentUploader
	belongs_to :user
	has_many :pages, dependent: :destroy
	validates :title, presence: true
end
