require_relative 'cart_item'

class Cart
  attr_reader :items, :total_price

  SKU_WIDTH = 5
  NAME_WIDTH = 15
  PRICE_WIDTH = 8
  QTY_WIDTH = 4

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

  def total_discount
    @discount.round(2)
  end

  def calculate_discount
    items.each do |item|
      rule = @discount_rules[item.product.sku]
      qty_rule = rule["quantity"].to_i
      return unless rule

      case rule["name"]

      when "second-item-free"
        free_items_count = (item.quantity / 2).floor
        @discount += item.product.price * free_items_count
        next

      when "total-percentage-discount"

        if item.quantity >= qty_rule
          @discount += item.total_price * rule["value"].to_f / 100
        end
        next

      when "single-price-discount"
        if item.quantity >= qty_rule
          @discount += (item.product.price - rule["value"].to_f) * item.quantity
        end
      end
    end
  end

  def checkout
    calculate_discount
    print_items
    puts "\nTotal price: #{total_price}"
    puts "Discount: #{total_discount}"
    puts "Final price: #{total_price - total_discount}"
  end

  def print_items
    puts "SKU".ljust(SKU_WIDTH) + "NAME".ljust(NAME_WIDTH) + "PRICE".ljust(PRICE_WIDTH) + "QTY".ljust(QTY_WIDTH)

    items.each do |item|
      puts item.product.sku.ljust(SKU_WIDTH) + \
     item.product.name.ljust(NAME_WIDTH) + \
     item.product.price.to_s.ljust(PRICE_WIDTH) + \
     item.quantity.to_s.ljust(QTY_WIDTH)
    end
  end
end
