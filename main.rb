#!/usr/bin/env ruby

require "csv"
require_relative "app/product"

CURRENCIES = {
  euro: { iso_name: "EUR", symbol: "€" }
}

def main(args)
  load_products

  if args.empty?
    puts "No arguments provided"
  elsif args[0] == "product-list"
    Product.print_all(@products)
  end
end

def load_products
  @products = []
  CSV.foreach("data/products.csv", headers: true) do |row|
    @products << Product.new(row[0], row[1], row[2].to_f)
  end
end

main(ARGV)
