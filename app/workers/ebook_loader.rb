class EbookLoader
	include Resque::Plugins::Status
	@queue = :ebooks_queue
	def perform
		ebook = Ebook.find(options['ebook_id'])
  	book = EPUB::Parser.parse(ebook.attachment.path)
		destination = "public/uploads/ebooks/#{ebook.title}"
  	unzip(ebook.attachment.path, destination)

  	book.each_page_on_spine do |pg|
      doc = Nokogiri::HTML(pg.read.squish.force_encoding('UTF-8'))
      body = doc.xpath('//body')
      path = File.join(destination, pg.entry_name)
      path.slice! "public/"
  		p = {}
  		p[:content] = body.to_s
    	p[:path] = path
  		@page = ebook.pages.create(p)
  	end
	end

  def unzip (file, destination)
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