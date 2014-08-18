class EbooksController < ApplicationController
  def index
  	@ebooks = Ebook.all
  end

  def new
  	@ebook = Ebook.new
  end

  def create
  	@ebook = Ebook.new(ebook_params)

  	puts @ebook.attachment.path
    puts "YAYYY"
    book = EPUB::Parser.parse(@ebook.attachment.path)
    @pages = Array.new
    puts "start"
    book.each_page_on_spine do |page|
      @pages.push(page.read.squish.force_encoding('UTF-8'))#.squish.force_encoding('ASCII-8BIT').encode('UTF-8', :invalid => :replace, :undef => :replace, :replace => '?'))
      puts page.read
    end
    puts "end"
    #puts pages
    #render :text => @pages.encode('UTF-8', :invalid => :replace, :undef => :replace)
    #render :text => ActionView::Base.full_sanitizer.sanitize("#{text}", :tags=>[])
    #if @resume.save
      #redirect_to resumes_path, notice: "The resume #{@resume.name} has been uploaded."
    #else
      render "create"
    #end
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
