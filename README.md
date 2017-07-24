# Ventes Prives Worker

### Requirements

Make sure redis is running on your environment :
 ```
 brew services start redis
 ```

## Run

1° On a first terminal run ```bundle exec sidekiq -r ./worker.rb```

2° On a second terminal start IRB :

  2°1 ``` bundle exec irb -r ./worker.rb```

  2°2 From IRB :
  ```
     VPLastEventWorker.perform_async()
  ```
