class Cart
  attr_reader :items

  def initialize
    @items = []
  end

  def add_item(product, quantity = 1)
    existing_item = @items.find { |item| item.product.sku == product.sku }

    if existing_item
      existing_item.quantity += quantity
    else
      @items << CartItem.new(product, quantity)
    end
  end

  def total_price
    @items.sum(&:total_price)
  end
end
