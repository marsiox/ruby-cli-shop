require 'spec_helper'
require_relative '../app/product'
require_relative '../app/cart'
require_relative '../app/cart_item'

RSpec.describe Cart do
  let(:gr1) { Product.new('GR1', 'Green Tea', 3.11) }
  let(:sr1) { Product.new('SR1', 'Strawberries', 5.00) }
  let(:cf1) { Product.new('CF1', 'Coffee', 11.23) }

  describe '#add_item' do
    let(:cart) { Cart.new }

    before do
      cart.add_item(gr1)
    end

    it 'adds item to cart' do
      expect(cart.items.size).to eq(1)
      expect(cart.items.first.product).to eq(gr1)
    end
  end

  describe '#total_price' do
    let(:cart) { Cart.new }

    before do
      cart.add_item(gr1)
      cart.add_item(gr1)
      cart.add_item(sr1)
    end

    it 'calculates quantities and total price' do
      expect(cart.items[0].quantity).to eq(2)
      expect(cart.items[1].quantity).to eq(1)
      expect(cart.final_price).to eq(11.22)
    end
  end

  describe '#discount_rules' do
    # config format: { sku: { name: 'rule-name', quantity: 3, value: 10 } }
    let(:discount_rules) {
      {
        "GR1" => { "name" => "GetSomeFreeDiscount", "quantity" => 2, "value" => 1 },
        "CF1" => { "name" => "PercentageDiscount", "quantity" => 3, "value" => 33.3333333333 },
        "SR1" => { "name" => "PriceDiscount", "quantity" => 3, "value" => 4.50 }
      }
    }

    before do
      allow(Configuration).to receive(:config).and_return({ "discount-rules" => discount_rules })
    end

    let(:cart) { Cart.new }

    context 'buy one get one free' do
      before do
        cart.add_item(gr1)
        cart.add_item(gr1)
        cart.apply_discounts
      end

      it 'calculates total price with discount' do
        expect(cart.final_price).to eq(3.11)
      end
    end

    context 'total percentage discount' do
      before do
        cart.add_item(sr1)
        cart.add_item(sr1)
        cart.add_item(gr1)
        cart.add_item(sr1)
        cart.apply_discounts
      end

      it 'calculates total price with discount' do
        expect(cart.final_price).to eq(16.61)
      end
    end

    context 'single price discount' do
      before do
        cart.add_item(gr1)
        cart.add_item(cf1)
        cart.add_item(sr1)
        cart.add_item(cf1)
        cart.add_item(cf1)
        cart.apply_discounts
      end

      it 'calculates total price with discount' do
        expect(cart.final_price).to eq(30.57)
      end
    end
  end
end
