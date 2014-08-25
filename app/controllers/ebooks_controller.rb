class EbooksController < ApplicationController
  def index
    if current_user
      @ebooks = current_user.ebooks
    else
      @ebook = nil
    end
  end

  def show
    @ebook = Ebook.find(params[:id])
    @pages = @ebook.pages.order("created_at ASC").paginate(:page => params[:page], :per_page => 1)
    render 'show', :layout => false
  end

  def new
  	@ebook = Ebook.new
  end

  def create
    @current_user = current_user
    book = EPUB::Parser.parse(params[:ebook][:attachment].path)
    params[:ebook][:title] = book.metadata.title
  	@ebook = @current_user.ebooks.create(ebook_params)
    if @ebook.save
      destination = "public/uploads/ebook/#{@current_user.name}/#{@ebook.title.tr(' ','_')}"
      puts "************"
      puts @ebook.attachment.path
      puts destination
      unzip(@ebook.attachment.path, destination)
      puts "************"

    	book.each_page_on_spine do |pg|
        doc = Nokogiri::HTML(pg.read.squish.force_encoding('UTF-8'))
        body = doc.xpath('//body')

    		p = {}
    		p[:content] = body.to_s
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
