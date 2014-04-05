#!/usr/bin/env ruby

require 'open-uri'
require 'nokogiri'

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

def getSubLinks(url, found)

    begin
        doc = Nokogiri(open(url, redirect: true))
    rescue OpenURI::HTTPError
       # Do nothing 
    end

    links = page_analyse(doc)

    if links
        links.each do |l|
            unless found.index(l)
                found << l

                grabWebsite(url + '/' + l, found)
            end
        end
    end
end


def grabWebsite(url, found = [])
    begin
        getSubLinks(url, found)
    rescue RuntimeError
        url = http_swap(url)
        getSubLinks(url, found)
    end

    found
end

# TODO: Grab the base of a url, no sub dirs
puts grabWebsite('http://digitalocean.com')
