JPL Space Calendar Parser
=====

This is the repo for the [http://jpl.mcginnis.io](http://jpl.mcginnis.io) app.

This app parses the [JPL Space Calendar](https://www2.jpl.nasa.gov/calendar/) and publishes the calendar in the following formats:

* **JSON**: [http://jpl.mcginnis.io/space_calendar.json](http://jpl.mcginnis.io/space_calendar.json)
* **iCalendar**: [http://jpl.mcginnis.io/space_calendar.ics](http://jpl.mcginnis.io/space_calendar.ics)

#### JSON Schema:

```json
[
  {
    "name": "Apollo Asteroid 2008 AG4 Near-Earth Flyby (0.094 AU)",
    "start_date": "2018-08-13",
    "end_date": "2018-08-13",
    "url": "http://ssd.jpl.nasa.gov/sbdb.cgi?orb=1;sstr=2008+AG4",
    "newly_added_date": null
  },
  {
    "name": "Aten Asteroid 2013 ND15 (Venus Trojan)Closest Approach To Earth (0.143 AU)",
    "start_date": "2018-08-13",
    "end_date": "2018-08-13",
    "url": "http://ssd.jpl.nasa.gov/sbdb.cgi?orb=1;sstr=2013+ND15",
    "newly_added_date": null
  },
  {
    "name": "Asteroid 498 Tokio Closest Approach To Earth (1.083 AU)",
    "start_date": "2018-08-13",
    "end_date": "2018-08-13",
    "url": "http://ssd.jpl.nasa.gov/sbdb.cgi?orb=1;sstr=498",
    "newly_added_date": null
  }
]
```

### Additional Helpful Links
* [Import Events to Google Calendar from URL](https://support.google.com/calendar/answer/37118?hl=en)
* [Import or Subscribe to a Calendar in Outlook.com](https://support.office.com/en-us/article/Import-or-subscribe-to-a-calendar-in-Outlook-com-cff1429c-5af6-41ec-a5b4-74f2c278e98c)
