require "sequel"
require "open-uri"
require "securerandom"

namespace :db do
  task :setup do
    DB = Sequel.connect(ENV['HEROKU_POSTGRESQL_SILVER_URL'])

    DB.create_table(:mood_logs) do
      primary_key :id
      String  :message
      Integer :recorded_at
    end

    DB.create_table(:reminder_logs) do
      primary_key :id
      Integer :delivered_at
    end
  end
end

namespace :app do
  task :remind do
    if (8..22).include?(Time.now.getlocal("-04:00").hour)
      if SecureRandom.random_number(6) == 0
        STDERR.puts("Sending message!")
        open(ENV["REMINDER_URL"])
      else
        STDERR.puts("Not this time")
      end
    end
  end
end
