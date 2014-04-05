#webpage_spec.rb

require 'webpage'

describe Webpage, "new" do
    it "creates a valid new object" do
        webpage = Webpage.new('')
        webpage.should be_nil

        address = "/"
        webpage = Webpage.new(address)

        webpage.node_name.should eql(address)
        webpage.site_links.count.should be 0 

    end

    it "can add links" do
        webpage = Webpage.new("/")
        subpage = Webpage.new("/about")
        webpage.add_link(subpage)

        webpage.site_links.length.should be 1
    end

    it "can find links" do
        webpage = Webpage.new("/")
        subpage = Webpage.new("/about")
        webpage.add_link(subpage)

        webpage.has_link?("/about").should be_true
        webpage.has_link?("/anaconda").should be_false
    end
end
