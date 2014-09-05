uri = URI.parse(ENV["REDISTOGO_URL"])
Resque.redis = Redis.new(:url => ENV['REDISTOGO_URL'])
