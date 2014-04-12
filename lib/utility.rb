
require 'webpage'

# Shared utility code
module Utility

    # Create a clean base url
    #
    # Removes parameters and # links on pages
    def self.strip_symbols(url)

      # Replace everything after and including:
      #   #, ?
      url = url.gsub(/([#\?].*)/, '')

      # Remove trailing slashes, unless there's only one
      url = url[0..-2] if url.length > 1 and url[-1] == '/'

      url
    end

    def self.find_link(ary, link)
        found = nil

        link = Webpage.new(link) if link.is_a? String

        ary.each do |page|

            if page.is_a? String
                webpage = Webpage.new(page)
            else
                webpage = page
            end

            # If the page has been visited before, we don't care about it
            unless webpage.is_copy?
                head = webpage == link

                unless head
                    found = Utility.find_link(webpage.site_links, link)
                else
                    found = webpage
                end

                break unless found.nil?
            end
        end

        found
    end

    def self.has_link?(ary, link)
        not find_link(ary, link).nil?
    end
end
