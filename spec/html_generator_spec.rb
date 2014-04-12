require 'spec_helper'

require 'html_generator'
require 'webpage'

require 'nokogiri'

describe HTMLGenerator, "build a website out of a list of pages" do

  def setup
    w = Webpage.new('/')
    w.add_page(Webpage.new('/about'))

    @html_gen = HTMLGenerator.new(w, @out_dir)
  end

  before(:each) do

    @out_dir = 'output_spec'
    setup

  end

  it "can generate the HTML files" do
    @html_gen.generate

    # Begin tests
    Dir.exists?(@out_dir).should be_true

    d = Dir.new(@out_dir)
    (d.count - 2).should be 2

    d.each do |file|
      # Skip the virtual paths dir picks up
      # Is there a flag for this?
      unless file == '.' or file == '..'
        f = open(@out_dir + '/' + file)

        doc = Nokogiri(f)

        doc.xpath('//ul').length.should be > 0

        # Make sure the stream is closed
        f.close
      end
    end

  end

  it "Creates a new directory on init" do

    if Dir.exists? @out_dir
      @html_gen.rm_r(@out_dir)
      Dir.delete(@out_dir) 
    end

    Dir.exists?(@out_dir).should be_false 

    setup
    @html_gen.generate

    Dir.exists?(@out_dir).should be_true 
  end
end
