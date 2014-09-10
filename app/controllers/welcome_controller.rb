class WelcomeController < ApplicationController
  def index
  	if current_user
  		redirect_to ebooks_path
  	end
  end
end
