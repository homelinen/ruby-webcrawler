
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

        raise 'PageOfTypeString' if page.class == String

        existing_page = get_page(page)

        # Add the new page
        page = existing_page if existing_page
        @site_links << page

        self
    end

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

    def ==(webpage)

        webpage.node_name == @node_name

    end

    def empty?
        site_links.empty?
    end

    alias :include? :has_link?
end
