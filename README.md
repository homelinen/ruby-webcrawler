# Web Crawler

## Installation

1. Clone it
1. Install the necessary gems: `bundle install --without development`
1. Run it `ruby -Ilib ./bin/webcrawler {{ website }}` where website is off the
   form: `http://myweb.site[:port]`

## Testing

To test you need the development gems in the Bundle.

To run some tests you are required to run a web server.

If you wish to run `rspec` as normal, please run `rake run_server` to start up
the hell server that serves the test website.

To kill the server simply run `rake kill_server`
