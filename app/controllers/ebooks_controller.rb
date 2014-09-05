class EbooksController < ApplicationController
  def index
    @ebook = Ebook.all
  end

  def show
    @ebook = Ebook.find(params[:id])
    @pages = @ebook.pages.order("created_at ASC").paginate(:page => params[:page], :per_page => 1)
    render 'show'
  end

  def new
  	@ebook = Ebook.new
  end

  def create
    title = EPUB::Parser.parse(params[:ebook][:attachment].path).metadata.title
    puts "************"

    params[:ebook][:title] = title
  	@ebook = Ebook.new(ebook_params)
    if @ebook.save
        Resque.enqueue(EbookUploader, @ebook.id, ENV['PUSHER_APP_ID'], ENV['PUSHER_KEY'], ENV['PUSHER_SECRET'])
        redirect_to ebook_path(@ebook)
    else
        render "create"
    end
  end

  def destroy
    dir = "public/uploads/ebooks"
    FileUtils.rm_rf(dir)
    Ebook.delete_all
  	redirect_to ebooks_path, notice: "Ebook deleted!"
  end

  def about
    @title = "About"
    render "about"
  end

  def contact
    @title = "Contact"
    render "contact"
  end

	private
   	 def ebook_params
    	  params.require(:ebook).permit(:title, :attachment)
   	 end
end
