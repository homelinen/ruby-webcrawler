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
def page_analyse(f)

    doc = Nokogiri(f)
    
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

    puts links
end

def grabWebsite(url)
    begin
        open(url, redirect: true) do |f|
            page_analyse(f)
        end
    rescue RuntimeError
        url = http_swap(url)
        open(url, redirect: true) do |f|
            page_analyse(f)
        end

    end
end

grabWebsite('http://digitalocean.com')
