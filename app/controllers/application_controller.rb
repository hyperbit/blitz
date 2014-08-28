class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def unzip (file, destination)

		Zip::Archive.open(file) do |ar|
		  ar.each do |zf|
	    	f_path = File.join(destination, zf.name)
		    if zf.directory?
		      FileUtils.mkdir_p(f_path)
		    else
		      dirname = File.dirname(f_path)
		      FileUtils.mkdir_p(dirname) unless File.exist?(dirname)

		      open(f_path, 'wb') do |f|
		        f << zf.read
		      end
		    end
		  end
		end

	end

  helper_method :unzip
end
