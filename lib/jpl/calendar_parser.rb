require 'open-uri'
require 'nokogiri'
require 'icalendar'
require 'active_support/cache'

module JPL
  class CalendarParser
    CALENDAR_URL = 'https://www2.jpl.nasa.gov/calendar/'.freeze
    DATE_FORMAT = '%Y %b %d'.freeze
    CACHE_EXPIRY = 1.hour

    def initialize
      @cache = ActiveSupport::Cache::MemoryStore.new(expires_in: CACHE_EXPIRY)
    end

    def to_ical
      ical = Icalendar::Calendar.new

      events.each do |event|
        ical_event = Icalendar::Event.new

        ical_event.dtstart = Icalendar::Values::Date.new(event[:start_date])
        ical_event.dtend = Icalendar::Values::Date.new(event[:end_date])
        ical_event.summary = event[:name]
        ical_event.description = event[:url]

        ical.add_event(ical_event)
      end

      ical.to_ical
    end

    def to_csv
      events.to_csv
    end

    def to_json
      events.to_json
    end

    private

    def events
      @events = @cache.read(:events)

      if @events.nil?
        @cache.write(:events, build_events)
        @events = @cache.read(:events)
      end

      @events
    end

    def build_events
      open(CALENDAR_URL) do |url|
        events = []

        Nokogiri::HTML(url).css('a[@name !=content]').each do |section|
          # month, year (eg. <h2>August 2018</h2>) from heading
          h2 = section.xpath('./h2').first.text
            .match(/\A(?<month>\w+)\s(?<year>\d{4})/)

          event_year = h2[:year]

          section.xpath('./ul/li').each do |event|
            event_text = event.text.strip.delete("\n")

            # skip events with no definitive start/end date (eg. Nov ??)
            next if event_text.include?('??')

            event_name = parse_event_name(event_text)
            event_link = parse_event_link(event)

            newly_added_date = parse_newly_added_date(event_text, event_year)
            date_text = event_text.gsub(event_name, '').strip
            start_date, end_date = parse_event_dates(date_text, event_year)

            next unless start_date && end_date

            events <<  {
              name: event_name,
              start_date: start_date,
              end_date: end_date,
              url: event_link,
              newly_added_date: newly_added_date
            }
          end
        end

        return events
      end
    end

    def parse_newly_added_date(event_text, event_year)
      if matches = event_text.match(/\[(.*)\]/)
        return Date.strptime("#{event_year} #{matches[1]}", DATE_FORMAT)
      end
    end

    def parse_event_link(event)
      event_link = event.xpath('string(./a/@href)')
      event_link.start_with?('http') ? event_link : nil
    end

    def parse_event_name(event_text)
      # Sep 23 -[Sep 11] Hugo von Seeliger's 170th Birthday (1849)
      if matches = event_text.match(/\A.*\]\s(.*)$/)
        return matches[1]
      end

      # Nov 01 - Asteroid 5805 Glasgow
      if matches = event_text.match(/\A.*\s-\s?(.*)$/)
        return matches[1]
      end

      event_text
    end

    def parse_event_dates(date_text, event_year)
      # single day events (eg. Aug 01 -)
      if matches = date_text.match(/\A(\w+)\s(\d+)\s-/)
        month, start_day = matches[1], matches[2]

        date_string = "#{event_year} #{month} #{start_day}"
        start_date = Date.strptime(date_string, DATE_FORMAT)

        return start_date, start_date
      end

      # multi-day same month events (eg. Jun 24-28 -, Aug 26-29 -[Sep 06])
      if matches = date_text.match(/\A(\w+)\s(\d+)-(\d+)\s-/)
        month, start_day, end_day = matches[1], matches[2], matches[3]

        start_date_string = "#{event_year} #{month} #{start_day}"
        end_date_string = "#{event_year} #{month} #{end_day}"

        return Date.strptime(start_date_string, DATE_FORMAT),
               Date.strptime(end_date_string, DATE_FORMAT)
      end

      # multi-day, multi-month events (eg. Aug 26-Sep 20 -)
      if matches = date_text.match(/\A(\w+)\s(\d+)-(\w+)\s(\d+)/)
        start_date_string = "#{event_year} #{matches[1]} #{matches[2]}"
        end_date_string = "#{event_year} #{matches[3]} #{matches[4]}"

        return Date.strptime(start_date_string, DATE_FORMAT),
               Date.strptime(end_date_string, DATE_FORMAT)
      end

    rescue ArgumentError
      return
    end
  end
end

