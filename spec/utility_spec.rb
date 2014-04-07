
require 'utility'

describe Utility, "provides utilities" do

    before(:each) do
        @arry = [
            Webpage.new('/'),
            Webpage.new('/about'),
            Webpage.new('/contact'),
            Webpage.new('/about/contract'),
        ]
    end

    it "can find links as strings" do
        Utility.has_link?(@arry, '/').should be_true
        Utility.has_link?(@arry, '/about').should be_true
        Utility.has_link?(@arry, '/contact').should be_true
        Utility.has_link?(@arry, '/about/contract').should be_true
        
        Utility.has_link?(@arry, '/friends').should be_false
        Utility.has_link?(@arry, '/about/friends').should be_false
    end

    it "can find links as pages" do

        Utility.has_link?(@arry, Webpage.new('/')).should be_true
        Utility.has_link?(@arry, Webpage.new('/about')).should be_true
        Utility.has_link?(@arry, Webpage.new('/contact')).should be_true
        Utility.has_link?(@arry, Webpage.new('/about/contract')).should be_true

        Utility.has_link?(@arry, Webpage.new('/friends')).should be_false
        Utility.has_link?(@arry, Webpage.new('/about/friends')).should be_false
    end
end
