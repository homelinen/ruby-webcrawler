# Generate a HTML representation of the graph of sites

require 'webpage'
require 'erb'

include ERB::Util

class HTMLGenerator

    def initialize(root_page, output_dir = 'output', prefix_domain='')

        @output_dir = output_dir
        @prefix_domain = prefix_domain

        # Make sure the output directory is setup
        begin 
            Dir.new(@output_dir)
        rescue Errno::ENOENT
            Dir.mkdir(@output_dir)
        end

        @root_page = root_page
    end

    def generate
        
        webpage = @root_page
        b = binding

        e = ERB.new(open('template/webpage.html.erb').read)

        result = e.result b

        f = open(@output_dir + "/#{url_encode(webpage.node_name)}.html", 'w')

        f.write(result)

        f.close
    end
end
