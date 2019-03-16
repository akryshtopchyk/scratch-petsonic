class Scratcher
  attr_accessor :items_attributes, :page_url

  def initialize(category_url, file_path = 'result.csv')
    @page_url = category_url
    @items_attributes = []
  end

  def get_category_items
    index = 1
    item = []
      loop do
        category_page = get_category_xml(index)
        items = category_page.css('a.product_img_link')
        items = category_page.xpath('//a[@class="product_img_link product-list-category-img"]/@href')
        puts "page #{index}: #{items.count} items"
        break unless items.any?
        items.each do |el|
          item_page = get_page_xml(el)
          item_image = item_page.xpath('//img[@id="bigpic"]/@src') #ссылка на картинку
          item_main_name = item_page.xpath('//h1[@class="product_main_name"]').text.strip #ссылка на имя
          item_weight = item_page.xpath('//span[@class="radio_label"]')
          item_price = item_page.xpath('//span[@class="price_comb"]')
          $i = 0
          full_inf = []


          while $i < item_weight.count  do
            full_inf.push({
                              Name: item_main_name  + ' - ' + item_weight[$i].text.strip,
                              Price: item_price[$i].text.strip,
                              Image: item_image.to_s
                          })

              $i +=1
          end
          full_inf.each do |el|
            CSV.open('data1.csv', 'a+') do |csv|
              if CSV.read('data1.csv').count == 0  # file is empty, so write header
                csv << full_inf.first.keys
              end
              csv << el.values
              puts 'done'
            end
          end
          #item_page.xpath('//span[@class="radio_label"]').each do |el|
          #  item << item_main_name + ' ' + el.text.strip
          #end
          #puts item
          #item_page.xpath('//span[@class="price_comb"]').each do |el|
          #  puts el.text.strip
          #end
          #осталось просто достать остальные атрибуты, используй item_page для этого (как с картинкой)
          puts el
          puts ' '

        index += 1
      end
      end
  end

  private

  def get_category_xml(page)
    url = page_url
    url += "/?p=#{page}" unless page == 1
    category_page_xml = get_page_xml(url)
  end

  def get_page_xml(url)
    page = Curl.get(url) do |http|
      http.headers['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10; rv:33.0) Gecko/20100101 Firefox/33.0'
    end
    page_xml = Nokogiri::HTML(page.body_str)
  end
end