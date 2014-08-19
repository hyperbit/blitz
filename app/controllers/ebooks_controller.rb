class EbooksController < ApplicationController
  def index
  	@ebooks = Ebook.all
  end

  def show
    @ebook = Ebook.find(params[:id])
    @pages = @ebook.pages.paginate(:page => params[:page], :per_page => 1)
    render 'show', :layout => false
  end

  def new
  	@ebook = Ebook.new
  end

  def create
  	@ebook = Ebook.new(ebook_params)
    if @ebook.save
    	book = EPUB::Parser.parse(@ebook.attachment.path)
    	book.each_page_on_spine do |pg|
    		p = {}
    		p[:content] = pg.read.squish.force_encoding('UTF-8')
    		@page = @ebook.pages.create(p)
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
