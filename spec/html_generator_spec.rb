require 'spec_helper'

require 'html_generator'
require 'webpage'

require 'nokogiri'

describe HTMLGenerator, "build a website out of a list of pages" do

  it "can generate the HTML files" do

    out_dir = 'output_spec'

    w = Webpage.new('/')
    w.add_page(Webpage.new('/about'))

    html_gen = HTMLGenerator.new(w, out_dir)

    html_gen.generate

    Dir.new(out_dir).should_not raise_error(Errno::ENOENT), 'Output directory should exist'

    d = Dir.new(out_dir)

    d.each do |file|
      unless file == '.' or file == '..'
        f = open(out_dir + '/' + file)

        doc = Nokogiri(f)

        doc.xpath('//ul').length.should be > 0

        # Make sure the stream is closed
        f.close
      end
    end

  end
end
