require 'nokogiri'
require 'curb'
require 'mechanize'
require 'csv'
require_relative 'scratcher'

category = ARGV[0]
# category = 'https://www.petsonic.com/snacks-huesos-para-perros/'
page_scratcher = Scratcher.new(category)
page_scratcher.get_category_items
