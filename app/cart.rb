class Cart
  def initialize
    @products = []
  end

  def add_product(product)
    @products << product
  end
end
