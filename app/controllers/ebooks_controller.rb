class EbooksController < ApplicationController
  def index
    if current_user
      @ebooks = current_user.ebooks
      @title = "Home"
    else
      redirect_to root_path
    end
    @ebook = Ebook.new
  end

  def show
    @ebook = Ebook.find(params[:id])
    @pages = @ebook.pages.order("created_at ASC").paginate(:page => params[:page], :per_page => 1)
    if params[:page]
      @ebook.update_attribute(:bookmark, params[:page])
    end
    @bookmark = @ebook.bookmark
    render 'show'
  end

  def create
    @current_user = current_user
    title = EPUB::Parser.parse(params[:ebook][:attachment].path).metadata.title

    params[:ebook][:title] = title
  	@ebook = @current_user.ebooks.create(ebook_params)
    if @ebook.save
        Resque.enqueue(EbookUploader, @ebook.id, ENV['PUSHER_APP_ID'], ENV['PUSHER_KEY'], ENV['PUSHER_SECRET'])
        redirect_to ebook_path(@ebook)
    else
        render "create"
    end
  end

  def destroy
    @current_user = current_user
    @ebook = Ebook.find(params[:id])
    dir = "public/uploads/ebooks/#{@ebook.user.name.to_s.tr(' ', '_')}/#{@ebook.title.tr(' ', '_')}"

    s3 = AWS::S3.new
    bucket_name = ENV['S3_BUCKET_NAME']
    s3.buckets[bucket_name].objects.with_prefix(dir).delete_all # delete directory contents
    s3.buckets[bucket_name].objects.delete(dir) # delete directory

    @ebook.destroy
    redirect_to ebooks_path, notice: "#{@ebook.title} deleted!"
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
