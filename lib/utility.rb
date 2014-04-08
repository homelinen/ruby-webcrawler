
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

    # Compare items if they are string or not
    def self.compare_pages(a, b)
        a = get_node_name(a)
        b = get_node_name(b)

        a == b
    end

    def self.has_link?(ary, link)
        ary.any? do |webpage|
            compare_pages(webpage, link)
        end
    end
end
