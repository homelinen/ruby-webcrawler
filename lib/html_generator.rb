# Generate a HTML representation of the graph of sites

require 'webpage'
require 'erb'

include ERB::Util

class HTMLGenerator

    def initialize(root_page, output_dir = 'output', prefix_domain='')

        @output_dir = output_dir
        @prefix_domain = prefix_domain
        if Dir.exist?(@output_dir)

            # Delete the old files
            Dir.new(@output_dir).each do |i| 
                unless i == '.' or i == '..'
                    File.delete(@output_dir + '/' + i)
                end
            end
        else
            Dir.mkdir(@output_dir) 
        end

        @root_page = root_page
    end

    def generate()
        
        e = ERB.new(open('template/webpage.html.erb').read)

        root_page = write_page(@root_page, e)

        root_page
    end

    private

    def fix_html(file_name)
        file_name = file_name + '.html' if /\.html$/.match(file_name).nil?
    end

    # Strip out slashes and replace with dashes
    def my_url_encode(url)
        # Replace / with -, drop the ?= part of a link
        url = url.sub('/', '').gsub(/\?.*/, '').gsub('/', '-')
    end

    def write_page(webpage, erb_template)
        b = binding
        result = erb_template.result b

        file_name = @output_dir + "/#{my_url_encode(webpage.node_name)}"

        fixed = fix_html(file_name)
        file_name = fixed unless fixed.nil?

        f = open(file_name, 'w')
        f.write(result)
        f.close

        webpage.site_links.each { |p| write_page(p, erb_template) }
        file_name
    end
end