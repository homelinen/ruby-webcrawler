require 'open-uri'
require 'openssl'
require 'open_uri_redirections'
require 'nokogiri'

require 'webpage'
require 'utility'

# A class for generating site maps
#
# The site map is operated on as a tree, but can be imagined as a graph.
# Pages that are already in the tree when added are marked as copies and can be
# used like the original
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

    # Check if an asset URL comes from the local site or a remote
    def is_foreign?(url, page=nil)

      page = @base_url if page.nil?
      
      different_site = false

      has_bad_scheme = url[0..1] == '//'

      different_site = url.match(page).nil? unless url[0] == '/'

      has_bad_scheme or different_site
    end

    # Get the asset source names as an array from the given document with the
    # given node name and attribute
    def get_asset(doc, node_name, attribute)
        assets = doc.xpath("//#{node_name}").map { |c| 
          c.attribute(attribute).value if c.attribute attribute
        }.compact

        assets.find_all do |a|
          not is_foreign?(a)
        end
    end

    # Analyse a page grabbed from the URLs
    #
    # TODO: More elegantly handle the else statement. An output of {} isn't very sane
    def page_analyse(doc)

        out = {}

        if doc
        
            # Get all the links href values
            hrefs = doc.xpath("//a/@href")

            out[:assets] = 
              get_asset(doc, 'link', 'href') + 
              get_asset(doc, 'script', 'src') + 
              get_asset(doc, 'img', 'src') 

            links = []

            hrefs.each do |href|
                # Check for a leading slash, most links will be of this form
                if /^\//.match(href.value)
                    links << href.value
                end
            end

            out[:links] = links.uniq
        end
        out
    end

    def has_link?(link)
        Utility.has_link?(found, link)
    end

    # The main operation for recursively fetching URLs and operating on the XML
    def getSubLinks(url, found)

        begin
            # Open and read the website
          #
          # INFO: Doesn't care if a cert is valid or if there are unsafe redirects
            doc = Nokogiri(open(
              url, 
              redirect: true, 
              ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE,
              allow_redirections: :all
            ))
        rescue OpenURI::HTTPError, URI::InvalidURIError
           # Do nothing 
        end

        analysed_doc = page_analyse(doc)

        links = analysed_doc[:links] if analysed_doc.has_key? :links
        found.assets = analysed_doc[:assets] if analysed_doc.has_key? :assets
        
        # Work on the child links of a page if they are not already contained in the root tree
        if links
            links.each do |l|
                l = Utility.strip_symbols(l)

                existing_link = Utility.find_link([@root_node], l)

                unless existing_link

                    wp = Webpage.new(l)
                    found.add_page wp

                    # Update the so far list, easier than joining two arrays
                    # per iter
                    #links_so_far << wp
                    grabWebsite(@base_url + l, wp)
                else
                    # TODO: Add to a webpages links if not already there
                    # TODO: Add an alternate link for each page
                    wp = Webpage.new(l, existing_link)
                    found.add_page wp
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

    # The main method to grab a website. Handles the root case and initialises the objects @root_node field
    def grabWebsite(url, found = nil)

        if found.nil?
            root = '/'

            root_page = Webpage.new(root)

            found = root_page
            @root_node = found
        end

        getBaseUrl(url)
        found = getSubLinks(url, found)

        found
    end
end
