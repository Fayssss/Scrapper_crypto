require 'nokogiri'
require 'open-uri'

class StartScrap

  def initialize(money_name)
    url="https://coinmarketcap.com/all/views/all/"
    @page = Nokogiri::HTML(open(url))
    @money_name = money_name
    @hash = {}
  end

  def perform
    name = @page.xpath('//a[@class="currency-name-container link-secondary"]').map { |link| link.text }
    price = @page.css('.price').map { |link| link.text }

    hash = name.zip(price).map{|name, price| {name: name, price: price}}
    @hash = hash.select {|hash| hash[:name] == @money_name}[0]
  end

  def save
    if @hash
      money = Money.find_by name: @hash[:name]
      if money
        money.update_attributes(price: @hash[:price])
      else
        money = Money.create!(@hash)     
      end
    else
      return false
    end
  end

end