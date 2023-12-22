require_relative 'configuration'
require_relative 'cart_item'
require_relative 'discount/base_discount'
require_relative 'discount/get_some_free_discount'
require_relative 'discount/percentage_discount'
require_relative 'discount/price_discount'

class Cart
  attr_reader :items, :total_price

  SKU_WIDTH = 5
  NAME_WIDTH = 15
  PRICE_WIDTH = 8
  QTY_WIDTH = 4

  def initialize
    @config = Configuration.config
    @discount = 0
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
    items.sum(&:total_price).round(2)
  end

  def total_discount
    @discount.round(2)
  end

  def final_price
    (total_price - total_discount).round(2)
  end

  def apply_discounts
    discount_rules = @config["discount-rules"]

    items.each do |item|
      rule = discount_rules[item.product.sku]
      return unless rule

      if item.quantity >= rule["quantity"].to_i
        klass = Object.const_get(rule["name"])
        discount = klass.new(item, rule).apply
        @discount += discount
      end
    end
  end

  def print_checkout
    print_items
    puts "\nTotal price: #{format_price(total_price)}"
    puts "Discount: #{format_price(total_discount)}"
    puts "Final price: #{format_price(final_price)}"
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
