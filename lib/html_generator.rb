# Generate a HTML representation of the graph of sites
# 
# Generate HTML pages detailing a Webpage

require 'webpage'
require 'erb'

include ERB::Util

class HTMLGenerator

    def initialize(root_page, output_dir = 'output', prefix_domain='')

        @output_dir = output_dir
        @prefix_domain = prefix_domain

        # Ensure we have a clean output directory to work with
        if Dir.exist?(@output_dir)
            rm_r(@output_dir)
        else
            Dir.mkdir(@output_dir) 
        end

        @root_page = root_page
    end

    # Generate the HTML pages based on the root_page passed in on init
    def generate
        
        e = ERB.new(open('template/webpage.html.erb').read)

        root_page = write_page(@root_page, e)

        root_page
    end

    # Remove all the contents in a directory
    def rm_r(dir)
        # Delete the old files
        Dir.new(dir).each do |i| 
            unless i == '.' or i == '..'
                File.delete(dir + '/' + i)
            end
        end
    end

    private

    # Ensure the newly modified names have .html file endings
    def fix_html(file_name)
        file_name = file_name + '.html' if /\.html$/.match(file_name).nil?
    end

    # Strip out slashes and replace with dashes, this is so browsers don't 
    # mangle the paths on the filesystem
    def my_url_encode(url)
        unless url == '/'
            # Replace / with -, drop the ?= part of a link
            url = url.sub('/', '').gsub(/\?.*/, '').gsub(/\/|\(|\)/, '-')
        else
            url = 'index.html'
        end
    end

    # Generate the page from a template
    #
    # Recurses into subpages if the page is not a copy
    def write_page(webpage, erb_template)

        b = binding
        result = erb_template.result b

        file_name = @output_dir + "/#{my_url_encode(webpage.node_name)}"

        fixed = fix_html(file_name)
        file_name = fixed unless fixed.nil?

        f = open(file_name, 'w')
        f.write(result)
        f.close

        webpage.site_links.each { |p| write_page(p, erb_template) unless p.is_copy? }
        file_name
    end
end
