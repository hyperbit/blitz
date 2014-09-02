class EbooksController < ApplicationController
  def index
    #Ebook.delete_all(["updated_at < ?", 12.hours.ago])
    @ebook = Ebook.all
  end

  def show
    @ebook = Ebook.find(params[:id])
    @pages = @ebook.pages.order("created_at ASC").paginate(:page => params[:page], :per_page => 1)
    @job_id = params[:job_id]
    status = Resque::Plugins::Status::Hash.get(params[:job_id]).status
    if status != "completed"
      render 'ebook'
    else
      render 'show', :layout => false
    end
  end

  def new
    #Ebook.delete_all(["updated_at < ?", 12.hours.ago])
  	@ebook = Ebook.new
  end

  def create
    book = EPUB::Parser.parse(params[:ebook][:attachment].path)
    params[:ebook][:title] = book.metadata.title
  	@ebook = Ebook.new(ebook_params)
    if @ebook.save
      #Resque.enqueue(EbookLoader, @ebook.id)
      job_id = EbookLoader.create(:ebook_id => @ebook.id)
      puts job_id
      redirect_to ebook_path(@ebook, :job_id => job_id)
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
	private
   	 def ebook_params
    	  params.require(:ebook).permit(:title, :attachment)
   	 end
end
