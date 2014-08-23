class WelcomeController < ApplicationController
  def index
  	if current_user
   		redirect_to ebooks_path
    else
    	render 'index', :layout => false
    end
  end
end
