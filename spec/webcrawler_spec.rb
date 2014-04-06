#webpage_spec.rb

require 'nokogiri'

require 'webcrawler'
require 'webpage'

describe Webcrawler, "utility" do

    it "can replace urls" do
        url = 'http://digitalocean.com'
        url_https = 'https://digitalocean.com'

        url_swapped = Webcrawler.http_swap(url)

        url_swapped.should eql(url_https)

        # Swapping again should equal the original
        Webcrawler.http_swap(url_swapped).should eql(url)

        url = 'http://digitaloceanhttp.com'
        url_https = 'https://digitaloceanhttp.com'
        Webcrawler.http_swap(url).should(eql(url_https), 'should not change the domain')
    end

    it "can find links in a file" do
        sitemap = Webcrawler.new

        doc = Nokogiri(open('./spec/files/test.html'))

        links = sitemap.page_analyse(doc)

        links.length.should be > 1
        links.should include("/")
        links.should include("/about")
        links.should include("/from")
        links.should_not include("/foo")

        links.uniq.should == links
    end

    it "can search a website" do
        # This must match the heel config in the Rakefile
        localsite = 'http://0.0.0.0:9999'

        sitemap = Webcrawler.new
        found = sitemap.grabWebsite localsite

        found.site_links.length.should be 1

        found.include?(Webpage.new('/')).should be_true
    end

    #it "can handle urls" do
        #site = '0.0.0.0:9999'

        #grabWebsite(site).should raise_error(Errno::ENOENT), 'No /https?/ included'
    #end
end
