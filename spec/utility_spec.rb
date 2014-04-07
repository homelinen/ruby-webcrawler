
require 'utility'

describe Utility, "provides utilities" do

    before(:each) do
        @arry = []
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
