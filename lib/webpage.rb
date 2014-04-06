
require './lib/utility'

class Webpage

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

    def add_link(link)
        @site_links << link
    end

    def to_s
        # Only get the node name for the tree
        site_links = @site_links.map { |s| s.node_name }
        @node_name + ' ' + site_links
    end

    def has_link?(link)
        Utility.has_link?(@site_links, link)
    end

    def eql?(webpage)

        webpage.node_name == @node_name

    end
end
