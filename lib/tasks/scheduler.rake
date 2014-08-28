desc "This task is called by the Heroku scheduler add-on"
task :destroy_ebooks => :environment do
  puts "Deleting all ebook ActiveRecords..."
  Ebook.destroy_ebooks
  puts "done."
end
