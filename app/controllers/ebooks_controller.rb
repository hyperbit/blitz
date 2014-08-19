class EbooksController < ApplicationController
  def index
  	@ebooks = Ebook.all
  end

  def new
  	@ebook = Ebook.new
  end

  def create
  	@ebook = Ebook.new(ebook_params)

    puts "YAYYY"
    
    @pages = Array.new
    puts "start"
    
    puts "end"
    #puts pages
    #render :text => @pages.encode('UTF-8', :invalid => :replace, :undef => :replace)
    #render :text => ActionView::Base.full_sanitizer.sanitize("#{text}", :tags=>[])
    if @ebook.save
    	book = EPUB::Parser.parse(@ebook.attachment.path)
  		puts @ebook.attachment.path
    	book.each_page_on_spine do |pg|
    		p = {}
    		p[:content] = pg.read.squish.force_encoding('UTF-8')
    		@page = @ebook.pages.create(p)
      	@pages.push(pg.read.squish.force_encoding('UTF-8'))#.squish.force_encoding('ASCII-8BIT').encode('UTF-8', :invalid => :replace, :undef => :replace, :replace => '?'))
      	puts pg.read
    	end
      redirect_to ebooks_path, notice: "The ebook #{@ebook.title} has been uploaded."
    else
      render "create"
    end
  end

  def destroy
  	@ebook = Ebook.find(params[:id])
  	@ebook.destroy
  	redirect_to ebooks_path, notice: "Ebook deleted!"
  end
	private
   	 def ebook_params
    	  params.require(:ebook).permit(:title, :attachment)
   	 end
end
