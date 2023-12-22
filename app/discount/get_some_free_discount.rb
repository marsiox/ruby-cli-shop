class GetSomeFreeDiscount < BaseDiscount
  def apply
    item.product.price * rule["value"].to_f
  end
end
