#!/usr/bin/env ruby

require "csv"
require "json"
require_relative "app/product"
require_relative "app/cart"
require_relative "app/configuration"

def main(args)
  @config = Configuration.config
  load_products

  cart = Cart.new(@config["discount-rules"])

  loop do
    print "Enter SKU (or 'exit'): "
    input = gets.chomp

    if input.downcase == "exit"
      break
    else
      puts "Scanned: #{input}"
      product = Product.find_by_sku(@products, input)

      unless product
        puts "Product not found"
        next
      end

      cart.add_item(product)
    end
  end

  puts "Checkout..."
  cart.checkout
end

def load_products
  @products = []
  CSV.foreach("data/products.csv", headers: true) do |row|
    @products << Product.new(row[0], row[1], row[2].to_f)
  end
end

main(ARGV)
