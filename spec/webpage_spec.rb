#webpage_spec.rb

require 'spec_helper'
require 'webpage'

describe Webpage, "new" do
    it "creates a valid new object" do
        webpage = Webpage.new('')
        webpage.should be_nil

        address = "/"
        webpage = Webpage.new(address)

        webpage.node_name.should eql(address)
        webpage.site_links.count.should be 0 
        webpage.error_code.should be 0
    end

    it "can add links" do
        webpage = Webpage.new("/")
        subpage = Webpage.new("/about")
        webpage.add_page(subpage)

        webpage.site_links.length.should be 1
    end

    it "can find links" do
        webpage = Webpage.new("/")
        subpage = Webpage.new("/about")
        webpage.add_page(subpage)

        webpage.has_link?("/about").should be_true
        webpage.has_link?("/anaconda").should be_false
    end

    it "can be compared" do 
        web1 = Webpage.new('/about')
        web2 = Webpage.new('/about')

        web2.should ==(web1)

        web3 = Webpage.new('/about/dance')
        web1.should_not ==(web3)

        web4 = Webpage.new('/')
        web1.should_not ==(web4)
    end

    it "can be a copy" do

        @page = Webpage.new('/about')

        @about = Webpage.new('/about', @page)

        @about.is_copy?.should be_true

    end

    it "can add links" do

        web1 = Webpage.new('/')

        old_about = Webpage.new('/about')
        # Check chaining exists
        web1.add_page(old_about).should equal(web1)

        web1.has_link?('/about').should be_true

        web2 = Webpage.new('/friends')
        new_about = Webpage.new('/about')
        web2.add_page(new_about)

        web1.add_page(web2)
        web1.get_page('/about').should == old_about
    end

    it "can find links of two types" do

        page = Webpage.new('/')
        page.has_link?(Webpage.new('/')).should be_true

        page.add_page(Webpage.new('/about'))
        page.has_link?(Webpage.new('/about')).should be_true

        # TODO: issue #7
        new_page = Webpage.new('/about').add_page(Webpage.new('/careers'))
        page.has_link?(new_page).should be_true, 
            'same node names should count as existing'
    end

    it "can be printed as a string" do
        node_name = '/'
        w = Webpage.new(node_name)
        w.to_s.should == "#<Webpage node_name: #{node_name}\n\tsite_links:\n>"

        node_name = '/friends'
        site_links = ['/about', '/project']
        w = Webpage.new(node_name)
        site_links.each { |s| w.add_page(Webpage.new(s)) }
        w.to_s.should == "#<Webpage node_name: #{node_name}\n\tsite_links:\n\t\t#{site_links[0]},\n\t\t#{site_links[1]}\n>"
    end

end
