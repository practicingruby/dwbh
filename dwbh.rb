require "twilio-ruby"
require "sinatra"
require "sequel"
require "csv"
require "date"

configure do
  DB = Sequel.connect(ENV['HEROKU_POSTGRESQL_SILVER_URL'])
end

get '/send-reminder' do
  client = Twilio::REST::Client.new(ENV['TWILIO_SID'], ENV['TWILIO_AUTH_TOKEN'])

  client.account.sms.messages.create(
    :from => ENV['TWILIO_FROM_NUMBER'],
    :to   => ENV['TWILIO_TO_NUMBER'],
    :body => "?"
  )

  DB[:reminder_logs].insert(:delivered_at => Time.now.to_i)
end

get '/record-mood' do
  DB[:mood_logs].insert(:recorded_at => Time.now.to_i, :message => params["Body"])

  content_type "text/plain"

  ""
end

get '/mood-logs.csv' do
  data = DB[:mood_logs].all.map { |e| 
    time = Time.at(Integer(e[:recorded_at])).getlocal("-04:00")
    date = time.to_date

    [ e[:recorded_at], e[:message], 
      (date - Date.new(2013,6,12)).to_i, time.hour, 
      date.strftime("%a"), date.wday ].to_csv 
  }.join

  content_type "application/csv"
  response.write(data)
end
