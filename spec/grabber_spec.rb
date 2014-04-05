#webpage_spec.rb

require 'nokogiri'

require 'grabber'
include Grabber

require 'webpage'

describe 'Grabber', "utility" do

    it "can replace urls" do
        url = 'http://digitalocean.com'
        url_https = 'https://digitalocean.com'

        url_swapped = http_swap(url)

        url_swapped.should eql(url_https)

        # Swapping again should equal the original
        http_swap(url_swapped).should eql(url)

        url = 'http://digitaloceanhttp.com'
        url_https = 'https://digitaloceanhttp.com'
        http_swap(url).should(eql(url_https), 'should not change the domain')
    end

    it "can find links in a file" do
        doc = Nokogiri(open('./spec/files/test.html'))

        links = page_analyse(doc)

        links.length.should be > 1
        links.should include("/")
        links.should include("/about")
        links.should include("/from")
        links.should_not include("/foo")

        links.uniq.should eql(links)
    end

    it "can search a website" do
        # This must match the heel config in the Rakefile
        localsite = 'http://0.0.0.0:9999'

        found = grabWebsite(localsite)

        found.length.should be 1

        has_link?(found, '/').should be_true
    end

    #it "can handle urls" do
        #site = '0.0.0.0:9999'

        #grabWebsite(site).should raise_error(Errno::ENOENT), 'No /https?/ included'
    #end
end
