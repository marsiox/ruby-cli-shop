class PercentageDiscount < BaseDiscount
  def apply
    item.total_price * rule["value"].to_f / 100
  end
end
