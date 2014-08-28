class EbooksController < ApplicationController
  def index
    Ebook.delete_all(["updated_at < ?", 30.seconds.ago])
    @ebook = Ebook.all
  end

  def show
    @ebook = Ebook.find(params[:id])
    @pages = @ebook.pages.order("created_at ASC").paginate(:page => params[:page], :per_page => 1)
    render 'show', :layout => false
  end

  def new
    Ebook.delete_all(["updated_at < ?", 30.seconds.ago])
  	@ebook = Ebook.new
  end

  def create
    book = EPUB::Parser.parse(params[:ebook][:attachment].path)
    params[:ebook][:title] = book.metadata.title
  	@ebook = Ebook.new(ebook_params)
    if @ebook.save
      destination = "public/uploads/ebook/#{@ebook.title.tr(' ', '_')}"
      unzip(@ebook.attachment.path, destination)

    	book.each_page_on_spine do |pg|
        doc = Nokogiri::HTML(pg.read.squish.force_encoding('UTF-8'))
        body = doc.xpath('//body')
        path = File.join(destination, pg.entry_name)
    		p = {}
    		p[:content] = body.to_s
        p[:path] = path
    		@page = @ebook.pages.create(p)
    	end
      redirect_to ebook_path(@ebook)
    else
      render "create"
    end
  end

  def destroy
  	@ebook = Ebook.find(params[:id])
    dir = ::Rails.root.join("tmp", @ebook.title)
    FileUtils.rm_rf(dir)
    @ebook.destroy
  	redirect_to ebooks_path, notice: "Ebook deleted!"
  end
	private
   	 def ebook_params
    	  params.require(:ebook).permit(:title, :attachment)
   	 end
end
