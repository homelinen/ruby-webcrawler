
require 'webpage'

# Shared utility code
module Utility

    def self.get_node_name(page)
        if page.is_a? Webpage
            page.node_name
        else
            page
        end
    end

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

    # Compare items if they are string or not
    def self.compare_pages(a, b)
        a = get_node_name(a)
        b = get_node_name(b)

        a == b
    end

    def self.has_link?(ary, link, visited = [])
        ary.any? do |webpage|

            # If the page has been visited before, we don't care about it
            unless visited.include?(webpage)
                head = compare_pages(webpage, link)

                visited << webpage

                unless head or webpage.is_a? String
                    Utility.has_link?(webpage.site_links, link, visited)
                else
                    head
                end
            else
                false
            end
        end
    end
end
