require_relative 'configuration'
require_relative 'cart_item'

class Cart
  attr_reader :items, :total_price

  SKU_WIDTH = 5
  NAME_WIDTH = 15
  PRICE_WIDTH = 8
  QTY_WIDTH = 4

  def initialize(discount_rules = {})
    @config = Configuration.config
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
    puts "\nTotal price: #{format_price(total_price)}"
    puts "Discount: #{format_price(total_discount)}"
    puts "Final price: #{format_price(total_price - total_discount)}"
  end

  def print_items
    puts "SKU".ljust(SKU_WIDTH) + "NAME".ljust(NAME_WIDTH) + "PRICE".ljust(PRICE_WIDTH) + "QTY".ljust(QTY_WIDTH)

    items.each do |item|
      puts item.product.sku.ljust(SKU_WIDTH) + \
     item.product.name.ljust(NAME_WIDTH) + \
     format_price(item.product.price).ljust(PRICE_WIDTH) + \
     item.quantity.to_s.ljust(QTY_WIDTH)
    end
  end

  def format_price(price)
    currency_symbol = @config["currency"]["symbol"]
    formatted_price = '%.2f' % price
    "#{currency_symbol}#{formatted_price}"
  end
end
