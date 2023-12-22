class BaseDiscount
  attr_reader :discount, :item, :rule

  def initialize(item, rule)
    @item = item
    @rule = rule
    @discount = 0
  end

  def apply
    raise NotImplementedError
  end
end
