class Product
  attr_reader :sku, :name, :price

  def self.print_all(products)
    puts "SKU | Name | Price\n\n"
    products.each { |product| puts product.print_line }
  end

  def initialize(sku, name, price)
    @sku = sku
    @name = name
    @price = price
  end

  def print_line
    "#{sku} | #{@name} | #{@price}"
  end
end
