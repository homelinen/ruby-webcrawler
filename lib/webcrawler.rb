require 'open-uri'
require 'nokogiri'

require 'webpage'
require 'utility'

# A site map is a tree of Webpages
class Webcrawler

    def initialize
        @base_url = ''
        @root_node = nil
    end

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

            links.uniq
        end
    end

    def has_link?(link)
        Utility.has_link?(found, link)
    end

    def getSubLinks(url, found)

        p url
        begin
            doc = Nokogiri(open(url, redirect: true))
        rescue OpenURI::HTTPError
           # Do nothing 
        end

        links = page_analyse(doc)
        
        # Make sure we search ourself
        # This needs to recurse through the DS
        #links_so_far = found.site_links + [found.node_name]

        if links
            links.each do |l|

                unless Utility.has_link?([@root_node], l)

                    wp = Webpage.new(l)
                    found.add_page wp

                    # Update the so far list, easier than joining two arrays
                    # per iter
                    #links_so_far << wp
                    grabWebsite(@base_url + l, found)
                else
                    # TODO: Add to a webpages links if not already there
                end
            end
        end

        found
    end
     
    def getBaseUrl(url)

        # http or https followed by ://
        # The url can be letters, numbers dashes an dots, optionally followed by a port
        rex = /https?:\/\/[\w\.\-]+(:\d+)?/

        @base_url = rex.match(url)[0]
    end

    def grabWebsite(url, found = nil)

        if found.nil?
            root = '/'

            root_page = Webpage.new(root)

            found = root_page
            @root_node = found
        end

        begin
            getBaseUrl(url)
            found = getSubLinks(url, found)
        rescue RuntimeError
            found = Webpage.new('_error')
        end

        found
    end
end
