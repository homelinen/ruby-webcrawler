
# Shared utility code
module Utility
    def self.has_link?(ary, link)
        puts ary
        puts link
        if link.class == String
            ary.any? do |webpage|
                webpage.node_name == link
            end
        else
            ary.any? do |webpage|
                webpage.node_name == link.node_name
            end
        end
    end
end
