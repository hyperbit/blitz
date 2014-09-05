web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
worker: env PRE_TERM_TIMEOUT=5 TERM_CHILD_SIGNAL=QUIT TERM_CHILD=1 bundle exec rake resque:work QUEUES=*