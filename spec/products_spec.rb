require 'spec_helper'
require_relative '../app/product'

RSpec.describe Product do
  describe '#display_products' do
    let(:product_hash) do
      [
        { sku: 'abc123', name: 'Banana', price: 33.22 },
        { sku: 'def456', name: 'Apple', price: 10.50 }
      ]
    end

    let(:products) { product_hash.map { |p| Product.new(p[:sku], p[:name], p[:price]) } }

    it 'displays product list' do
      expected_output = "SKU | Name | Price\n\n" + products.map { |p| "#{p.sku} | #{p.name} | #{p.price}" }.join("\n") + "\n"

      expect { Product.print_all(products) }.to output(expected_output).to_stdout
    end
  end
end
