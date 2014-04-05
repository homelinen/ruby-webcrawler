
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
        found = false
        
        @site_links.each do |webpage|
            # TODO: Handle if webpage is a string?
            if webpage.node_name == link
                found = true
                break
            end
        end

        found
    end
end
