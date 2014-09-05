require 'pusher'

class EbookUploader
	@queue = :upload_ebook
	def self.perform(ebook_id, pusher_app_id, pusher_key, pusher_secret)
		Pusher.app_id = pusher_app_id
		Pusher.key = pusher_key
		Pusher.secret = pusher_secret

		Pusher.trigger('ebook-uploader', 'ebook-percent', {:message => "started"})

		ebook = Ebook.find(ebook_id)
		book = EPUB::Parser.parse(ebook.attachment.path)
		destination = "public/uploads/ebooks/#{ebook.title}"
		unzip(ebook.attachment.path, destination)

		num = 0.0
		total = book.each_page_on_spine.count.to_f
    	book.each_page_on_spine do |pg|
	        doc = Nokogiri::HTML(pg.read.squish.force_encoding('UTF-8'))
	        body = doc.xpath('//body')
	        path = File.join(destination, pg.entry_name)
	        path.slice! "public/"
    		p = {}
    		p[:content] = body.to_s
        	p[:path] = path
    		page = ebook.pages.create(p)
    		num += 1.0
    		percent = ((num/total) * 100).to_i.to_s
    		Pusher.trigger('ebook-uploader', 'ebook-percent', {:message => percent})
    	end
    		Pusher.trigger('ebook-uploader', 'ebook-percent', {:message => "done"})
	end

	def self.unzip (file, destination)
		Zip::Archive.open(file) do |ar|
			ar.each do |zf|
		    	f_path = File.join(destination, zf.name)
			    if zf.directory?
		    		FileUtils.mkdir_p(f_path)
			    else
					dirname = File.dirname(f_path)
					FileUtils.mkdir_p(dirname) unless File.exist?(dirname)

					open(f_path, 'wb') do |f|
						f << zf.read
			    	end
			    end
			end
		end
	end
end