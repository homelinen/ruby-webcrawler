# Web Crawler

A web crawler written in Ruby. Recurses through a website as if it were a tree
and generates a HTML website to represent the links between sites.

No database is required, all operations are performed in memory. (This means if
it crashes it loses it's progress)

## Installation

1. Clone it
1. Install the necessary gems: `bundle install --without development`
1. Run it `ruby -Ilib ./bin/webcrawler {{ website }}` where website is off the
   form: `http://myweb.site[:port]`
1. The map of the URLs is output to the `output/` folder by default.
   `output/index.html` is a good place to start.

## Testing

To test you need the development gems in the Bundle.

To run some tests you are required to run a web server.

If you wish to run `rspec` as normal, please run `rake run_server` to start up
the hell server that serves the test website.

To kill the server simply run `rake kill_server`

