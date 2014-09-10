class Ebook < ActiveRecord::Base
	mount_uploader :attachment, AttachmentUploader
	belongs_to :user
	has_many :pages, dependent: :destroy
	validates :title, presence: true
	validates :attachment, presence: true,
		:file_size => { :maximum => 25.megabytes.to_i }
end
