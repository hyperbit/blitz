class PagesController < ApplicationController
	def show
    puts "**************"
    @page = Page.find(params[:ebook_id])
    #puts params.inspect()
    #@ebooks = Ebook.paginate(:page => params[:page])
    #puts @ebook.pages.inspect()
    #@pages = @ebook.pages.paginate(:page => params[:id])
    #puts @pages
    puts "**************"
    #@pg = Page.all
    #puts @pg
    puts "**************"
    render 'show'
  end
end
