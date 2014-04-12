
require './lib/utility'

# A representation of a site in a site map
#
# A site has many links and is a recursive tree structure
# If a page is a copy it should have no site_links and be as minimal in memory as possible.
# Storing pages as pointers in the tree proved problematic and the current method is slightly clearer.
#
# TODO: Wrap methods for the case where the webpage is a copy, just need to
# redirect the commands to the origin page
class Webpage

    #TODO: Pages should have a domain? 

    attr_accessor :node_name, :site_links, :error_code, :assets

    # Naive check to make sure node_names are valid
    def self.new(node_name, copy = nil)
        # Check for invalid web names
        # Should be an exception?
        return nil if node_name.empty?
        super
    end

    def initialize(node_name, copy = nil)
        @node_name = node_name
        @site_links = []
        @error_code = 0
        @copy = copy
        @assets = []
    end

    def is_copy?
        not @copy.nil?
    end

    # Deprecated: use Utility.find_link()
    def get_page(page)

        unless page.class == String
            @site_links.detect do |p|
                p == page
            end
        else
            @site_links.detect do |p|
                p.node_name == page
            end
        end
    end

    # Add a page to the tree
    def add_page(page)

        # TODO: Simply convert the string to a page
        raise 'PageOfTypeString' if page.class == String

        existing_page = get_page(page)

        # Add the new page
        page = existing_page if existing_page
        @site_links << page

        self
    end

    # Pretty printer for the Webpage
    #
    # TODO: Have recursive indentation on child nodes
    def to_s
        # Only get the node name for the tree
        site_links = @site_links.map { |s| s.node_name }

        # This nightmarish string prints, as an example:
        # #<Webpage node_name: /
        #     site_links:
        #       /about,
        #       /project
        # >
        "#<Webpage node_name: #{@node_name}\n\tsite_links:#{"\n\t\t" unless site_links.empty?}#{site_links.join(",\n\t\t")}\n>"
    end

    # Wrap the utility method has_link? for convenience
    def has_link?(link)
        is_me = 
            if link.class == String
                @node_name == link
            else
                @node_name == link.node_name
            end

        unless is_me
            Utility.has_link?(@site_links, link)
        else
            is_me
        end
    end

    # Only compare pages based on node_name
    #
    # TODO: Handle alternative names
    def ==(webpage)
        webpage.node_name == @node_name
    end

    def set_error_code(error_code)
        @error_code = error_code
    end

    alias :include? :has_link?
end
