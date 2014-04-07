require 'open-uri'
require 'nokogiri'

require 'webpage'
require 'utility'

# A site map is a tree of Webpages
class Webcrawler

    # Given a url, find and replace http or https to the alternate form
    #
    # This is to patch the feature in open-url that blocks https -> http redirection
    def self.http_swap(url)

        # If we don't set new_url again, return the original
        new_url = url

        # Match non-https
        m = /http[^s]/.match url

        if m
            new_url = url.gsub(/http:/, 'https:')
        elsif /https:\/\//.match(url)
            new_url = url.gsub(/https:/, 'http:')
        end

        new_url
    end

    # Analyse a page grabbed from the URLs
    def page_analyse(doc)

        if doc
        
            # Get all the links href values
            hrefs = doc.xpath("//a/@href")

            links = []

            hrefs.each do |href|
                # Check for a leading slash, most links will be of this form
                if /^\//.match(href.value)
                    links << href.value
                end
            end

            links.uniq!
        end
    end

    def has_link?(link)
        Utility.has_link?(found, link)
    end

    def getSubLinks(url, found)

        begin
            doc = Nokogiri(open(url, redirect: true))
        rescue OpenURI::HTTPError
           # Do nothing 
        end

        links = page_analyse(doc)
        
        links_so_far = found.site_links << found.node_name

        if links
            links.each do |l|

                unless Utility.has_link?(links_so_far, l)

                    wp = Webpage.new(l)
                    found.add_link wp

                    # Update the so far list, easier than joining two arrays
                    # per iter
                    links_so_far << wp
                    grabWebsite(url + '/' + l, found)
                else
                    # TODO: Add to a webpages links if not already there
                end
            end
        end
    end

    def grabWebsite(url, found = nil)

        if found.nil?
            root = '/'

            root_page = Webpage.new(root)

            found = root_page
        end

        begin
            getSubLinks(url, found)
        rescue RuntimeError
            url = http_swap(url)
            getSubLinks(url, found)
        end

        found
    end
end