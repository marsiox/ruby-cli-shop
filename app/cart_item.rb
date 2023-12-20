class CartItem
  attr_accessor :product, :quantity

  def initialize(product, quantity = 1)
    @product = product
    @quantity = quantity
  end

  def total_price
    @product.price * @quantity
  end
end
