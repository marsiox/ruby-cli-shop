class PriceDiscount < BaseDiscount
  def apply
    (item.product.price - rule["value"].to_f) * item.quantity
  end
end
