#!/usr/bin/env ruby

require 'open-uri'
require 'nokogiri'

require './lib/webpage'

module Grabber
    # Given a url, find and replace http or https to the alternate form
    #
    # This is to patch the feature in open-url that blocks https -> http redirection
    def http_swap(url)

        # If we don't set new_url again, return the original
        new_url = url

        # Match non-https
        m = /http[^s]/.match url

        if m
            new_url = url.gsub(/http:/, 'https:')
        elsif /https:\/\//.match(url)
            new_url = url.gsub(/https:/, 'http:')
        end

        new_url
    end

    # Analyse a page grabbed from the URLs
    def page_analyse(doc)

        if doc
        
            # Get all the links href values
            hrefs = doc.xpath("//a/@href")

            links = []

            hrefs.each do |href|
                # Check for a leading slash, most links will be of this form
                if /^\//.match(href.value)
                    links << href.value
                end
            end

            links.uniq!
        end
    end

    def has_link?(ary, link)

        found = false
        
        ary.each do |webpage|
            if webpage.node_name == link
                found = true
                break
            end
        end

        found
    end

    def getSubLinks(url, found)

        begin
            doc = Nokogiri(open(url, redirect: true))
        rescue OpenURI::HTTPError
           # Do nothing 
        end

        links = page_analyse(doc)

        if links
            links.each do |l|
                unless has_link?(found, l)

                    wp = Webpage.new(l)
                    found << wp

                    grabWebsite(url + '/' + l, found)
                else
                    # TODO: Add to a webpages links if not already there
                end
            end
        end
    end


    def grabWebsite(url, found = [])

        if found.empty?
            root = '/'

            root_page = Webpage.new(root)

            found << root_page
        end
        begin
            getSubLinks(url, found)
        rescue RuntimeError
            url = http_swap(url)
            getSubLinks(url, found)
        end

        found
    end
end

# TODO: Grab the base of a url, no sub dirs
#puts Grabber.grabWebsite('http://digitalocean.com')
