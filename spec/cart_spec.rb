require 'spec_helper'
require_relative '../app/product'
require_relative '../app/cart'
require_relative '../app/cart_item'

RSpec.describe Cart do
  let(:product1) { Product.new('abc123', 'Banana', 33.22) }
  let(:product2) { Product.new('def456', 'Apple', 10.50) }
  let(:product3) { Product.new('ghi789', 'Orange', 20.22) }

  describe '#add_item' do
    let(:cart) { Cart.new }

    before do
      cart.add_item(product1)
    end

    it 'adds item to cart' do
      expect(cart.items.size).to eq(1)
      expect(cart.items.first.product).to eq(product1)
    end
  end

  describe '#total_price' do
    let(:cart) { Cart.new }

    before do
      cart.add_item(product1)
      cart.add_item(product1)
      cart.add_item(product2)
    end

    it 'calculates total price' do
      expect(cart.items.first.quantity).to eq(2)
      expect(cart.total_price).to eq(76.94)
    end
  end

  describe '#apply_discount_rules' do
  # config format: { sku: { name: 'rule-name', quantity: 3, value: 10 } }
    let(:discount_rules) {
      {
        "abc123" => { name: "second-item-free" },
        "def456" => { name: "total-percentage-discount", quantity: 3, value: 10 },
        "ghi789" => { name: "single-price-discount", quantity: 3, value: 15.50 }
      }
    }

    let(:cart) { Cart.new(discount_rules) }

    context 'buy one get one free' do
      before do
        cart.add_item(product1)
        cart.add_item(product1)
        cart.add_item(product1)
        cart.calculate_discount
      end

      it 'calculates total price with discount' do
        expect(cart.total_price).to eq(product1.price * 2)
      end
    end

    context 'total percentage discount' do
      before do
        cart.add_item(product2)
        cart.add_item(product2)
        cart.add_item(product2)
        cart.calculate_discount
      end

      it 'calculates total price with discount' do
        expect(cart.total_price).to eq(product2.price * 3 * 0.9)
      end
    end

    context 'single price discount' do
      before do
        cart.add_item(product3)
        cart.add_item(product3)
        cart.add_item(product3)
        cart.calculate_discount
      end

      it 'calculates total price with discount' do
        expect(cart.total_price).to eq(15.50 * 3)
      end
    end
  end
end
