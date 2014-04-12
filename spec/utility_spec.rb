
require 'spec_helper'
require 'utility'

describe Utility, "provides utilities" do

    before(:each) do
        @links = ['/', '/about', '/contact', '/about/contract']
        @false_links = ['/friends', '/about/false']

        @arry = @links.map { |l| Webpage.new(l) }
    end

    it "can find links as strings" do
        @links.each do |l|
            Utility.has_link?(@arry, l).should be_true
        end
        
        @false_links.each do |l|
            Utility.has_link?(@arry, l).should be_false
        end
    end

    it "can find links as pages" do

        @links.each do |l|
            Utility.has_link?(@arry, Webpage.new(l)).should be_true
        end
        
        @false_links.each do |l|
            Utility.has_link?(@arry, Webpage.new(l)).should be_false
        end
    end
end

describe Utility, "string arrays" do
    before(:each) do
        @links = ['/', '/about', '/contact', '/about/contract']
        @false_links = ['/friends', '/about/false']

        @arry = @links
    end

    it "can find links as strings" do
        @links.each do |l|
            Utility.has_link?(@arry, l).should be_true
        end
        
        @false_links.each do |l|
            Utility.has_link?(@arry, l).should be_false
        end
    end

    it "can find links as pages" do

        @links.each do |l|
            Utility.has_link?(@arry, Webpage.new(l)).should be_true
        end
        
        @false_links.each do |l|
            Utility.has_link?(@arry, Webpage.new(l)).should be_false
        end
    end
end

describe Utility, "Deep Links" do

    before(:each) do
        @root = Webpage.new('/')
        about = Webpage.new('/about').add_page Webpage.new('/about/project')

        @root.add_page(about)
    end

    it "can find a page deep in the tree" do

        Utility.has_link?([@root], Webpage.new('/about/project')).should be_true
    end

    it "can find a page in a recursive tree" do
        @root.add_page(Webpage.new('/contact').add_page(Webpage.new('/about')))
        Utility.has_link?([@root], Webpage.new('/about/project')).should be_true
    end

    it "can find one in a tree of doubles" do
      @root.add_page(Webpage.new('/projects').add_page(Webpage.new('/about/project')))

      Utility.find_link([@root], '/about/project').should be == Webpage.new('/about/project')
    end
end

describe Utility, "link sanitiser" do

  it "can strip out nonsense" do
    links = [
      ["/my/awesome/site","/my/awesome/site?p=123,q=red"],
      ["wonderful-site-magic", "wonderful-site-magic#sublink"],
      ["/my/folder", "/my/folder/"],
      ["/", "/"]
    ]

    links.each do |link_test|
      Utility.strip_symbols(link_test[1]).should == link_test[0]
    end
  end
end
