require 'nokogiri'
require 'curb'
require 'mechanize'

category = 'https://www.petsonic.com/snacks-huesos-para-perros'
index = 2
loop do
  category_page = Curl.get("#{category}/?p=#{index}") do |http|
    http.headers['User-Agent'] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10; rv:33.0) Gecko/20100101 Firefox/33.0"
  end
  category_page = Nokogiri::HTML(category_page.body_str)
  items = category_page.css("a.product_img_link")
  puts "#{index} : #{items.count}"
  break unless items.any?
  category_page.css("a.product_img_link").each do |el|
     puts el.to_h["href"]
  end
  index += 1
end

