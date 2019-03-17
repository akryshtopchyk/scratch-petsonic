class Scratcher
  attr_accessor :items_attributes, :page_url, :file_path

  def initialize(category_url, file_path = 'result.csv')
    @page_url = category_url
    @items_attributes = []
  end

  def get_category_items
    index = 1
    loop do
      category_page = category_xml(index)
      items = category_page.xpath('//a[@class="product_img_link product-list-category-img"]/@href')
      puts "parsing page #{index}"
      break unless items.any?
      items.each do |el|
        item_page = page_xml(el)
        item_image, item_main_name, item_weight, item_price = item_attrs(item_page).values
        if item_weight.count == 0
          item_price = item_page.xpath('//span[@id="our_price_display"]').text.strip
          items_attributes << [item_main_name, item_price.to_f, item_image.to_s]
        else
          item_weight.each_with_index do |item_weight_el, item_index|
            items_attributes << [
                item_main_name + ' - ' + item_weight_el.text.strip,
                item_price[item_index].text.strip.to_f,
                item_image.to_s
            ]
            print '.'
          end
        end
      end
      puts ' '
      index += 1
    end
  end

  def export_into_csv(filename, file_param)
    puts 'exporting into csv file...'
    CSV.open("#{filename}" + '.csv', file_param.to_s) do |csv|
      csv << %w[name price image]
      items_attributes.each do |item_attributes|
        csv << item_attributes
      end
    end
    puts 'done, filename: ' + filename
  end

  private

  def item_attrs(item_page)
    {
      item_image: item_page.xpath('//img[@id="bigpic"]/@src'),
      item_main_name: item_page.xpath('//h1[@class="product_main_name"]').text.strip,
      item_weight: item_page.xpath('//span[@class="radio_label"]'),
      item_price: item_page.xpath('//span[@class="price_comb"]')
    }
  end

  def category_xml(page)
    url = page_url
    url += "/?p=#{page}" unless page == 1
    category_page_xml = page_xml(url)
  end

  def page_xml(url)
    page = Curl.get(url) do |http|
      http.headers['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10; rv:33.0) Gecko/20100101 Firefox/33.0'
    end
    page_xml = Nokogiri::HTML(page.body_str)
  end
end