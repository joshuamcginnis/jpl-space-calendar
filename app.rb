require 'sinatra'
require './lib/jpl/calendar_parser'

class App < Sinatra::Application
  configure do
    enable :logging
    set calendar: JPL::CalendarParser.new
  end

  get '/' do
    redirect '/space_calendar.json'
  end

  get '/space_calendar.ics' do
    content_type 'text/calendar'
    body settings.calendar.to_ical
  end

  get '/space_calendar.json' do
    content_type :json
    body settings.calendar.to_json
  end
end

App.run!
