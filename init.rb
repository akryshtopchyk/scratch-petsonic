require 'nokogiri'
require 'curb'
require 'mechanize'
require 'csv'
require_relative 'lib/scratcher'

category = ARGV[0]
file_path = ARGV[1] || 'export.csv'
file_param = ARGV[2] || 'w++'
# category = 'https://www.petsonic.com/snacks-huesos-para-perros/'
page_scratcher = Scratcher.new(category, file_path)
page_scratcher.get_category_items
page_scratcher.export_into_csv(file_path, file_param)
