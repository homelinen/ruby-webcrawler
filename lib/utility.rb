
# Shared utility code
module Utility
    def self.has_link?(ary, link)

        found = false
        
        ary.each do |webpage|
            if webpage.node_name == link
                found = true
                break
            end
        end

        found
    end
end
