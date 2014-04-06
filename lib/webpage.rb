
require './lib/utility'

# A representation of a site in a site map
#
# A site has many links and is a recursive tree structure
class Webpage

    #TODO: Pages should have a domain? 

    attr_accessor :node_name, :site_links

    def self.new(node_name)
        # Check for invalid web names
        # Should be an exception?
        return nil if node_name.empty?
        super
    end

    def initialize(node_name)
        @node_name = node_name
        @site_links = []
    end

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
        existing_page = get_page(page)

        # Add the new page
        page = existing_page if existing_page
        @site_links << page

        self
    end

    def to_s
        # Only get the node name for the tree
        site_links = @site_links.map { |s| s.node_name }
        @node_name + ' ' + site_links
    end

    def has_link?(link)
        is_me = false

        is_me = @node_name == link
        is_me = @node_name == link.node_name unless link.class == String or is_me

        unless is_me
            Utility.has_link?(@site_links, link)
        else
            is_me
        end
    end

    def ==(webpage)

        webpage.node_name == @node_name

    end

    alias :include? :has_link?
end
