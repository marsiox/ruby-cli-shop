class Cart
  attr_reader :items, :total_price

  def initialize(discount_rules = {})
    @discount = 0
    @discount_rules = discount_rules
    @items = []
  end

  def add_item(product, quantity = 1)
    existing_item = items.find { |item| item.product.sku == product.sku }

    if existing_item
      existing_item.quantity += quantity
    else
      items << CartItem.new(product, quantity)
    end
  end

  def total_price
    (items.sum(&:total_price) - @discount).round(2)
  end

  def calculate_discount
    items.each do |item|
      rule = @discount_rules[item.product.sku]
      return unless rule

      case rule[:name]
      when 'second-item-free'
        free_items_count = (item.quantity / 2).floor
        @discount += item.product.price * free_items_count
        break

      when 'total-percentage-discount'
        if item.quantity >= rule[:quantity]
          @discount += item.total_price * rule[:value] / 100
        end
        break

      when 'single-price-discount'
        if item.quantity >= rule[:quantity]
          @discount += (item.product.price - rule[:value]) * item.quantity
        end
      end
    end
  end
end
