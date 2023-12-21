class Product
  attr_reader :sku, :name, :price

  def self.find_by_sku(products, sku)
    products.find { |product| product.sku == sku }
  end

  def initialize(sku, name, price)
    @sku = sku
    @name = name
    @price = price
  end
end
